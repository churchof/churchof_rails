class AddRosmRequestIdToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :rosm_request_id, :integer
  end
end