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
    charge = Stripe::Charge.create(amount: cents,
                                   currency: @stripe_currency,
                                   card: @stripe_token,
                                   description: "Support of #{need.title}")
    true
  rescue Stripe::CardError
    false
  end

  before_create :assign_to_contributor_and_user
  
  def assign_to_contributor_and_user
    # find the appropriate contributor to associate this with
    # if no contributor exists with this email then make one.
    # set this contribution's contributor to the appropriate contributor.
    self.contributor = Contributor.where(:email => self.email).first_or_create do |contributor|
      contributor.email = self.email
      # associate that contributor with the user if one exists.
      contributor.user = User.where(:email => self.email).first
    end
    # if the contributor has an account but isnt logged in currently
    self.user = User.where(:email => self.email).first
    true
  end

end
