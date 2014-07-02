class AddOrganizationTypeToOrganization < ActiveRecord::Migration
  def change
  	add_column :organizations, :organization_type, :integer
  end
end
