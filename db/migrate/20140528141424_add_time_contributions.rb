class AddTimeContributions < ActiveRecord::Migration
  def change
  	create_table :time_contributions do |t|
      t.integer :user_id
      t.integer :need_id
      t.timestamps
    end
  end
end