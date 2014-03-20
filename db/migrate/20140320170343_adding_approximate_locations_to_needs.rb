class AddingApproximateLocationsToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :approx_latitude, :decimal, {:precision=>15, :scale=>10}
	add_column :needs, :approx_longitude, :decimal, {:precision=>15, :scale=>10}
  end
end
