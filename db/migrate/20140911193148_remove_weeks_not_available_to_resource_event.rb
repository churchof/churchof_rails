class RemoveWeeksNotAvailableToResourceEvent < ActiveRecord::Migration
  def change
  	remove_column :resource_events, :not_available_week_1, :boolean
  	remove_column :resource_events, :not_available_week_2, :boolean
  	remove_column :resource_events, :not_available_week_3, :boolean
  	remove_column :resource_events, :not_available_week_4, :boolean
  	remove_column :resource_events, :not_available_week_5, :boolean
  end
end
