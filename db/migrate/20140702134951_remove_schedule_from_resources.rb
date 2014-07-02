class RemoveScheduleFromResources < ActiveRecord::Migration
  def change
  	remove_column :resources, :schedule
  end
end
