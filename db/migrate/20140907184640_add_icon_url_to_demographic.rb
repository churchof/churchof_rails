class AddIconUrlToDemographic < ActiveRecord::Migration
  def change
  	    add_column :demographics, :icon_url, :string
  end
end
