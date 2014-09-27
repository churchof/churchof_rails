class AddMatchContributionFields < ActiveRecord::Migration
  def change
  	add_column :match_contributions, :need_id, :integer
  	add_column :match_contributions, :match_campaign_id, :integer
  end
end
