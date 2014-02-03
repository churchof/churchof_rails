class AddPublicOnToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :is_public, :boolean
  	add_index :needs, :is_public
  end
end
