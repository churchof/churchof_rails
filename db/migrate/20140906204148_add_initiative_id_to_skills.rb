class AddInitiativeIdToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :initiative_id, :integer
  end
end
