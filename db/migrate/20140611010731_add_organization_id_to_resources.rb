class AddOrganizationIdToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :organization_id, :integer
  end
end
