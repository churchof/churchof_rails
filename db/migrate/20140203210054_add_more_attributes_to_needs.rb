class AddMoreAttributesToNeeds < ActiveRecord::Migration
  def change
  	add_column :needs, :first_name, :string
  	add_index :needs, :first_name
  	add_column :needs, :last_name, :string
  	add_index :needs, :last_name
  	add_column :needs, :social_security_number, :string
  	add_index :needs, :social_security_number
  	add_column :needs, :street_address, :string
  	add_index :needs, :street_address
  	add_column :needs, :drivers_license, :string
  	add_index :needs, :drivers_license
  	add_column :needs, :age, :integer
  	add_index :needs, :age
  	add_column :needs, :gender, :integer
  	add_index :needs, :gender
  	add_column :needs, :title_public, :string
  	add_index :needs, :title_public
  	add_column :needs, :description_public, :text
  	add_index :needs, :description_public
  end
end