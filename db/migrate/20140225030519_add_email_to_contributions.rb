class AddEmailToContributions < ActiveRecord::Migration
  def change
  	add_column :contributions, :email, :string
  end
end
