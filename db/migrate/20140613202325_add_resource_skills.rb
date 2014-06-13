class AddResourceSkills < ActiveRecord::Migration
  def change
  	create_table :resources_skills do |t|
    	t.belongs_to :resource
      	t.belongs_to :skill
    end

  end
end
