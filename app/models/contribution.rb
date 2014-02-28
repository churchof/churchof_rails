class Contribution < ActiveRecord::Base
  belongs_to :need
  belongs_to :user
  belongs_to :contributor

  attr_writer :stripe_token
  attr_writer :stripe_currency

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

  before_create :assign_to_user_or_contributor
  
  def assign_to_user_or_contributor
    # if a current user was logged in then the contributon's user should be set.
    # check to see if there is no user.
    if !self.user
      # check to see if there is a user that just wasn't signed in.
      @user_by_email = User.where(:email => self.email).first
      if @user_by_email
        # if they werent signed in then go ahead and set it to them.
        self.user = @user_by_email
      else
        # if there is no user then make a contributor.
        self.contributor = Contributor.where(:email => self.email).first_or_create do |contributor|
          contributor.email = self.email
        end
      end
    else
      # if there is a user account that means no email address would have been typed in. so we'll set this here.
      self.email = self.user.email;
    end
    true
  end

end
