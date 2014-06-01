class AddCompletionGoalDateToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :completion_goal_date, :timestamp
  end
end
