class AddAssociatedOrganizationUrlToUser < ActiveRecord::Migration
  def change
  	add_column :users, :associated_organization_url, :string
  end
end
