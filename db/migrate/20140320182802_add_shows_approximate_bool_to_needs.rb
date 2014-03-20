class AddShowsApproximateBoolToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :shows_real_location_publically, :boolean
  end
end
