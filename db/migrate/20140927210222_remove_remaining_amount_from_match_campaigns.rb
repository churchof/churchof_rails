class RemoveRemainingAmountFromMatchCampaigns < ActiveRecord::Migration
  def change
  	remove_column :match_campaigns, :remaining_amount_cents
  end
end
