class AddCompletedDateToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :date_marked_completed, :timestamp
  end
end
