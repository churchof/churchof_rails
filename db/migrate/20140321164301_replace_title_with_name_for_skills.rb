class ReplaceTitleWithNameForSkills < ActiveRecord::Migration
  def change
  	remove_column :skills, :title
	add_column :skills, :name, :string
  end
end
