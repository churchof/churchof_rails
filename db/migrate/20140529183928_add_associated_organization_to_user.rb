class AddAssociatedOrganizationToUser < ActiveRecord::Migration
  def change
  	add_column :users, :associated_organization, :string
  end
end
