class CreateInitiatives < ActiveRecord::Migration
  def change
    create_table :initiatives do |t|

      t.timestamps
     t.string :title

    end
  end
end
