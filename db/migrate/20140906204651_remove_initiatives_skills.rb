class RemoveInitiativesSkills < ActiveRecord::Migration
  def change
  	drop_table :initiatives_skills
  end
end
