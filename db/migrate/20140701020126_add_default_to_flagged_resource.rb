class AddDefaultToFlaggedResource < ActiveRecord::Migration
  def change


  end

  def up
  	change_column :resources, :flagged, :boolean, :default => true
	end

	def down
	  change_column :resources, :flagged, :boolean, :default => nil
	end

end
