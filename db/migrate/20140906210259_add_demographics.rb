class AddDemographics < ActiveRecord::Migration
  def change
  	create_table :demographics do |t|
      t.timestamps
      t.string :title
    end
  end
end
