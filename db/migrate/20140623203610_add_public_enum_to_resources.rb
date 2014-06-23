class AddPublicEnumToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :public_status, :integer
  end
end
