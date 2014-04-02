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

  def mail_to_church_admin
    # should this be async?
    Mailer.church_admin_need_recieved_contribution(self.need.user_church_admin, self.need, self).deliver
  end

  def mail_to_user_posted_by
    # should this be async?
    Mailer.user_posted_by_need_recieved_contribution(self.need.user_posted_by, self.need, self).deliver
  end


  # Probably don't want these, just so there is no way money gets lost
  #validates :need, presence: true
  #validates :contributor, presence: true

  def process_payment
    charge = Stripe::Charge.create(amount: amount_cents,
                                   currency: @stripe_currency,
                                   card: @stripe_token,
                                   description: "Support of #{need.title}")
    true
  rescue Stripe::CardError
    false
  end

  private

  def assign_to_user_or_contributor
    self.user ||= User.find_by_email(email)
    if user
      self.email ||= user.email
    else
      self.contributor = Contributor.where(email: email).first_or_create
    end
  end
end
