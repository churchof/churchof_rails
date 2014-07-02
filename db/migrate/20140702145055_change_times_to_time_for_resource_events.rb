class ChangeTimesToTimeForResourceEvents < ActiveRecord::Migration
  def change
  	remove_column :resource_events, :start_hour
  	remove_column :resource_events, :start_minute
  	remove_column :resource_events, :end_hour
  	remove_column :resource_events, :end_minute

  	add_column :resource_events, :start_time, :time
  	add_column :resource_events, :end_time, :time
  end
end
