class AddUseridIndexToContributor < ActiveRecord::Migration
  def change
  	add_index :contributors, :user_id
  end
end
