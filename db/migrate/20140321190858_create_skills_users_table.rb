class CreateSkillsUsersTable < ActiveRecord::Migration
  def change
    create_table :skills_users do |t|
    	t.belongs_to :skill
      	t.belongs_to :user
    end
  end
end
