class AddWebsiteToOrganizations < ActiveRecord::Migration
  def change
  	add_column :organizations, :website_url, :string
  end
end
