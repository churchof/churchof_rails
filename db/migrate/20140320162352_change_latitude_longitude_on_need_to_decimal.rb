class ChangeLatitudeLongitudeOnNeedToDecimal < ActiveRecord::Migration
  def change
  	remove_column :needs, :latitude
  	remove_column :needs, :longitude
	add_column :needs, :latitude, :decimal, {:precision=>10, :scale=>6}
	add_column :needs, :longitude, :decimal, {:precision=>10, :scale=>6}
  end
end
