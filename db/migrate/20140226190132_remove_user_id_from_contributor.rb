class RemoveUserIdFromContributor < ActiveRecord::Migration
  def change
  	remove_column :contributors, :user_id
  end
end
