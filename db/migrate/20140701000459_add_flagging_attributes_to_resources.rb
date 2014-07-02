class AddFlaggingAttributesToResources < ActiveRecord::Migration
  def change
  	create_table :resource_flags do |t|
    	t.integer :resource_id
    	t.integer :user_id_church_admin
      	t.boolean :flagged
    end
  end
end