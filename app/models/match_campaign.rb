class MatchCampaign < ActiveRecord::Base

  has_many :match_contributions
  belongs_to :organization

  validates :organization_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :initial_amount, presence: true

  monetize :initial_amount_cents

	def self.current_active_campaign
		if self.active.count > 0
			self.active.first
		else
			nil
		end
	end

	scope :active, -> { where("? BETWEEN start_date AND end_date", Time.now.to_date)}

	def remaining_amount
		money = Money.new(0, "USD")
		self.match_contributions.not_reimbursed.each do |match_contribution|
		  money = money + match_contribution.amount
    end
    self.initial_amount - money
	end

end