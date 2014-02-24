class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :email
      t.timestamps
    end
  end
end
