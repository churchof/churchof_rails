class Contribution < ActiveRecord::Base
  belongs_to :need
  belongs_to :user
  belongs_to :contributor

  monetize :amount_cents

  attr_writer :stripe_token
  attr_writer :stripe_currency

  before_create :assign_to_user_or_contributor

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
    unless user?
      self.contributor = Contributor.where(email: email).first_or_create
    else
      self.email ||= user.email
    end
  end
end
