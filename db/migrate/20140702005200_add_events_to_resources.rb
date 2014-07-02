class AddEventsToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :schedule, :text
  end
end