class AddRolesMaskToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles_mask, :integer, :default => 1
    
    User.find_each do |u|
      u.update_column(:roles_mask, 1)
    end
  end
end