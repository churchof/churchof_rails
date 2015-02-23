class AddMatchContributions < ActiveRecord::Migration
  def change
  	create_table :match_campaigns do |t|
      t.timestamps
      t.timestamp :start_date
      t.timestamp :end_date
    	t.integer :initial_amount_cents
    	t.integer :remaining_amount_cents
    	t.integer :organization_id
    end

  	create_table :match_contributions do |t|
      t.timestamps
    	t.integer :contribution_id
			t.boolean :is_full_match
			t.integer :amount_cents
			t.boolean :paid
			t.boolean :reimbursed
    end

  end
end
