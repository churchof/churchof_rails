class AddDefaultValueToNeeds < ActiveRecord::Migration
  def change
    change_column :needs, :recipient_size, :integer, :default => 1
    change_column :needs, :frequency_type, :integer, :default => 1
  end
end
