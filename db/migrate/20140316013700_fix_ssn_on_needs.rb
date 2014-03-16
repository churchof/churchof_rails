class FixSsnOnNeeds < ActiveRecord::Migration
  def change
  	remove_column :needs, :social_security_number
	add_column :needs, :last_four_ssn, :string, :limit => 4
  end
end
