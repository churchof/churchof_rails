class AddFieldsToActivity < ActiveRecord::Migration
  def change
  	add_column :activities, :subject_id, :integer
  	add_column :activities, :subject_type, :string
  	add_column :activities, :user_id, :integer
  	add_column :activities, :description, :text
  end
end
