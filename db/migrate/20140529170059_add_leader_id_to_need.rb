class AddLeaderIdToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :user_id_need_leader, :integer
  	add_index :needs, :user_id_need_leader
  end
end
