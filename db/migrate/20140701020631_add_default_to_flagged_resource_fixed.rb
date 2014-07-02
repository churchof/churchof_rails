class AddDefaultToFlaggedResourceFixed < ActiveRecord::Migration
  def change

  	remove_column :resources, :flagged
  	add_column :resources, :flagged, :boolean, :default => false
  end
end
