class UpdatingNeedsToHaveMultipleUsersAssociated < ActiveRecord::Migration
  def change
  	remove_column :needs, :user_id

  	add_column :needs, :user_id_posted_by, :integer
  	add_index :needs, :user_id_posted_by
  	
  	add_column :needs, :user_id_church_admin, :integer
  	add_index :needs, :user_id_church_admin
  end
end
