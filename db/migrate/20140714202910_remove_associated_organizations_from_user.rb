class RemoveAssociatedOrganizationsFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :associated_organization
  	remove_column :users, :associated_organization_url
  end
end
