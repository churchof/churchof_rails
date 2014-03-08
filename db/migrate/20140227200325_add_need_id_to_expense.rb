class AddNeedIdToExpense < ActiveRecord::Migration
  def change
  	add_column :expenses, :need_id, :integer
  	add_index :expenses, :need_id
  end
end
