class AddConnectionsToInitiatives < ActiveRecord::Migration
  def change

  	add_column :initiative_metrics, :initiative_id, :integer

  	create_table :initiatives_skills do |t|
    	t.belongs_to :initiative
      	t.belongs_to :skill
    end

  end
end
