class AddStreetAddressToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :full_street_address, :string
  end
end
