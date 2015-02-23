class AddWeeksNotAvailableToResourceEvent < ActiveRecord::Migration
  def change
  	add_column :resource_events, :not_available_week_1, :boolean
  	add_column :resource_events, :not_available_week_2, :boolean
  	add_column :resource_events, :not_available_week_3, :boolean
  	add_column :resource_events, :not_available_week_4, :boolean
  	add_column :resource_events, :not_available_week_5, :boolean
  end
end
