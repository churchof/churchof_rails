class RemoveLeaderStringFromNeed < ActiveRecord::Migration
  def change
  	remove_column :needs, :leader
  end
end
