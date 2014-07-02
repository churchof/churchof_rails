class AddFlaggedToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :flagged, :boolean
  end
end
