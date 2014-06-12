class AddOrganizationRole < ActiveRecord::Migration
  def change
  	create_table :organization_role do |t|
	  	t.timestamps
	    t.integer :user_id
	    t.integer :organization_id
	    t.integer :role_type
	   	t.boolean :pending
    end
  end
end
