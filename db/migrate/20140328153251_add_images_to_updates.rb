class AddImagesToUpdates < ActiveRecord::Migration
  def change
  	add_attachment :images, :image
  	add_column :images, :update_id, :integer
  	add_index :images, :update_id
  end
end