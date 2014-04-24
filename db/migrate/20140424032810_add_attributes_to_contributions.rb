class AddAttributesToContributions < ActiveRecord::Migration
  def change
  	add_column :contributions, :succeded, :boolean
  	add_column :contributions, :reimbursed, :boolean
  end
end
