class AddVolunteerAttributesToNeed < ActiveRecord::Migration
  def change
  	add_column :needs, :volunteersNeededCount, :integer
  	add_column :needs, :additionalVolunteersSignedUpCount, :integer
  	add_column :needs, :volunteerTime, :timestamp
  	add_column :needs, :volunteerLocation, :string
  	add_column :needs, :volunteerDescription, :string
  end
end
