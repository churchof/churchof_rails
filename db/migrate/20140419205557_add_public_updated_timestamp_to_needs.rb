class AddPublicUpdatedTimestampToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :date_public_posted, :timestamp
  end
end
