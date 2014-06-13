class AddResources < ActiveRecord::Migration
  def change
  	create_table :resources do |t|
	  	t.timestamps
	    t.string :title
	    t.text :description
	    t.string :website
	   	t.string :contact_phone
	    t.string :contact_email
      	t.integer :user_id
      	t.integer :availability_status
      	t.string :status
	    t.string :address
	    t.decimal "latitude", precision: 15, scale: 10
	   	t.decimal "longitude", precision: 15, scale: 10
    end
  end
end
