class ReplaceMoneyWithRubyMoneyAttributes < ActiveRecord::Migration
  def change
  	remove_column :contributions, :cents
  	remove_column :expenses, :amount
  	add_column :contributions, :amount_cents, :integer
  	add_column :expenses, :amount_cents, :integer
  end
end
