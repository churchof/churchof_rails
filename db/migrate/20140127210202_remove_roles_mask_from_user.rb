class RemoveRolesMaskFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :roles_mask
  end
end
