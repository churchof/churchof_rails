class CreateInitiativeMetrics < ActiveRecord::Migration
  def change
    create_table :initiative_metrics do |t|
      t.timestamps
      t.string :title
    end
  end
end
