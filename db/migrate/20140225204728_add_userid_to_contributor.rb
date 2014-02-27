class AddUseridToContributor < ActiveRecord::Migration
  def change
  	add_column :contributors, :user_id, :integer
  end
end