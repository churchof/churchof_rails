class AddOrganizations < ActiveRecord::Migration
  def change
  	create_table :organizations do |t|
	  	t.timestamps
	    t.string :title
	    t.text :description
	    t.string :address
	    t.decimal "latitude", precision: 15, scale: 10
	   	t.decimal "longitude", precision: 15, scale: 10
    end
  end
end
