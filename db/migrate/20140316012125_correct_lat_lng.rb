class CorrectLatLng < ActiveRecord::Migration
  def change
  	remove_column :needs, :lat
  	remove_column :needs, :lng
	add_column :needs, :latitude, :float
	add_column :needs, :longitude, :float
  end
end
