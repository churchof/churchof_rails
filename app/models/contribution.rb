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
end
