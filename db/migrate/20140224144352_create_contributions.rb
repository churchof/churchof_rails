class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :contributor_id
      t.integer :user_id
      t.integer :need_id
      t.integer :cents
      t.string :stripe_token
      t.timestamps
    end
  end
end
