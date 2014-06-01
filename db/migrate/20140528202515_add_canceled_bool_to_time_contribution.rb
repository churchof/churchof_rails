class AddCanceledBoolToTimeContribution < ActiveRecord::Migration
  def change
  	add_column :time_contributions, :cancelled, :boolean
  end
end