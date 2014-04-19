class Contribution < ActiveRecord::Base
  belongs_to :need
  belongs_to :user
  belongs_to :contributor

  monetize :amount_cents

  attr_writer :stripe_token
  attr_writer :stripe_currency

  before_create :assign_to_user_or_contributor

  after_create :mail_to_church_admin
  after_create :mail_to_user_posted_by
  after_create :mail_to_users_who_contributed_if_fully_funded
  after_create :mail_receipt

  def mail_to_church_admin
    # should this be async?
    Mailer.church_admin_need_recieved_contribution(self.need.user_church_admin, self.need, self).deliver
  end

  def mail_to_user_posted_by
    # should this be async?
    Mailer.user_posted_by_need_recieved_contribution(self.need.user_posted_by, self.need, self).deliver
  end


  def mail_receipt
    # should this be async?
    if self.user
      Mailer.receipt_to_user(self.need.user_posted_by, self.need, self).deliver
    elsif self.contributor
      Mailer.receipt_to_contributor(self.need.user_posted_by, self.need, self).deliver
    end
  end


  # Probably don't want these, just so there is no way money gets lost
  #validates :need, presence: true
  #validates :contributor, presence: true

  def process_payment
                                  logger.debug "-+-+- 7"

    charge = Stripe::Charge.create(amount: amount_cents,
                                   currency: @stripe_currency,
                                   card: @stripe_token,
                                   description: "Support of #{need.title}")
                                  logger.debug "-+-+- 8"

    true
  rescue Stripe::CardError
                                  logger.debug "-+-+- 9"

    false
  end

  private

  def assign_to_user_or_contributor
    self.user ||= User.find_by_email(email)
    if user
      self.email ||= user.email
      Activity.create(
        subject: self,
        description: 'User made contribution.',
        user: self.user
      )
    else
      self.contributor = Contributor.where(email: email).first_or_create
      Activity.create(
        subject: self,
        description: 'Contributor made contribution.',
        user: self.user
      )
    end
  end

  def mail_to_users_who_contributed_if_fully_funded
    if self.need.percent_raised == 100
      if self.need.total_expenses > Money.new(0, "USD")
        # Alert the church admin
        past_relevant_activities = Activity.where(user_id: self.need.user_church_admin.id, subject: self.need, description: 'Mailed news that need is fully funded to Church Admin.')
        if past_relevant_activities.count == 0
          # Only email the user if they haven't been emailed about it yet.
          Mailer.church_admin_need_fully_funded(self.need.user_church_admin, self.need).deliver
          Activity.create(
            subject: self.need,
            description: 'Mailed news that need is fully funded to Church Admin.',
            user: self.need.user_church_admin
          )
        end
        # Alert the need poster
        past_relevant_activities = Activity.where(user_id: self.need.user_posted_by.id, subject: self.need, description: 'Mailed news that need is fully funded to Need Poster.')
        if past_relevant_activities.count == 0
          # Only email the user if they haven't been emailed about it yet.
          Mailer.user_posted_by_need_fully_funded(self.need.user_posted_by, self.need).deliver
          Activity.create(
            subject: self.need,
            description: 'Mailed news that need is fully funded to Need Poster.',
            user: self.need.user_posted_by
          )
        end
        # Alert the contributors (with/without accounts)
        self.need.contributions.each do |contribution|
          if contribution.user
            past_relevant_activities = Activity.where(user_id: contribution.user.id, subject: self.need, description: 'Mailed news that need is fully funded to contributor (with account).')
            if past_relevant_activities.count == 0
              # Only email the user if they haven't been emailed about it yet.
              Mailer.user_need_contributed_to_fully_funded(contribution.user, self.need).deliver
              Activity.create(
                subject: self.need,
                description: 'Mailed news that need is fully funded to contributor (with account).',
                user: contribution.user
              )
            end
          elsif contribution.contributor
            past_relevant_activities = Activity.where(user_id: nil, subject: self.need, description: 'Mailed news that need is fully funded to contributor (without account - #{contribution.contributor.email}).')
            if past_relevant_activities.count == 0
              # Only email the user if they haven't been emailed about it yet.
              Mailer.contributor_need_contributed_to_fully_funded(contribution.contributor, self.need).deliver
              Activity.create(
                subject: self.need,
                description: 'Mailed news that need is fully funded to contributor (without account - #{contribution.contributor.email}).',
                user: nil
              )
            end
          end
        end
      end
    end
  end

end
