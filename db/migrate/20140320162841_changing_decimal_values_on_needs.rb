class ChangingDecimalValuesOnNeeds < ActiveRecord::Migration
  def change
  	remove_column :needs, :latitude
  	remove_column :needs, :longitude
	add_column :needs, :latitude, :decimal, {:precision=>15, :scale=>10}
	add_column :needs, :longitude, :decimal, {:precision=>15, :scale=>10}
  end
end
