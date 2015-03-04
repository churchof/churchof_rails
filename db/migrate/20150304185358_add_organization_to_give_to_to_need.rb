class AddOrganizationToGiveToToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :organization_to_give_to_id, :integer
  end
end
