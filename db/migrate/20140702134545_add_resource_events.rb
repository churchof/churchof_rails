class AddResourceEvents < ActiveRecord::Migration
  def change
  	create_table :resource_events do |t|
    	t.integer :resource_id
    	t.text :schedule
      	t.integer :start_hour
      	t.integer :start_minute
      	t.integer :end_hour
      	t.integer :end_minute
    end
  end
end
