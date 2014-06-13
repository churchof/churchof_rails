class ChangeOrganizationRole < ActiveRecord::Migration
  def change

  	drop_table :organization_role
  	create_table :organization_roles do |t|
	  	t.timestamps
	    t.integer :user_id
	    t.integer :organization_id
	    t.integer :role_type
	   	t.boolean :pending
    end
  end
end
