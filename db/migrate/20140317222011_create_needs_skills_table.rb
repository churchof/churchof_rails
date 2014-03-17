class CreateNeedsSkillsTable < ActiveRecord::Migration
  def change
    create_table :needs_skills do |t|
    	t.belongs_to :need
      	t.belongs_to :skill
    end
  end
end
