class Expense < ActiveRecord::Base
	belongs_to :need
	validates :amount_cents, presence: true
	monetize :amount_cents
end