class AddVariousToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :recipient_size, :integer
  	add_index :needs, :recipient_size
  	add_column :needs, :frequency_type, :integer
  	add_index :needs, :frequency_type
  	add_column :needs, :recipient_contribution, :text
  	add_column :needs, :date_of_birth, :string
	add_column :needs, :lat, :decimal, {:precision=>10, :scale=>6}
	add_column :needs, :lng, :decimal, {:precision=>10, :scale=>6}
	add_column :needs, :leader, :string
  end
end
