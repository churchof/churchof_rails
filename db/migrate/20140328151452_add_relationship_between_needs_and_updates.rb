class AddRelationshipBetweenNeedsAndUpdates < ActiveRecord::Migration
  def change
  	add_column :updates, :need_id, :integer
  	add_index :updates, :need_id
  end
end
