class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :title
      t.integer :amount
      t.text :description
      t.string :documentation

      t.timestamps
    end
  end
end
