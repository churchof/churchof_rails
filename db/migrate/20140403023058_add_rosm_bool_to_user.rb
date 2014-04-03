class AddRosmBoolToUser < ActiveRecord::Migration
  def change
  	add_column :users, :is_full_rosm_member, :boolean
  end
end
