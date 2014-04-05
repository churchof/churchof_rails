class RemoveAgeFromNeed < ActiveRecord::Migration
  def change
  	remove_column :needs, :age
  end
end
