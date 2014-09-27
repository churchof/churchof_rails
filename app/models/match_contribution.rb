class MatchContribution < ActiveRecord::Base
  belongs_to :contribution
  belongs_to :match_campaign
  belongs_to :need

  validates :contribution_id, presence: true
  validates :match_campaign_id, presence: true

  monetize :amount_cents

  scope :not_reimbursed, -> { where(reimbursed: false) }

end