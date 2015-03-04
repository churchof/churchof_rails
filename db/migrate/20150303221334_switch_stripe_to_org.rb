class SwitchStripeToOrg < ActiveRecord::Migration
  def change
  	  remove_column :users, :stripe_publishable_key
      remove_column :users, :stripe_provider
      remove_column :users, :stripe_uid
      remove_column :users, :stripe_access_code

  	  add_column :organizations, :stripe_publishable_key, :string
      add_column :organizations, :stripe_provider, :string
      add_column :organizations, :stripe_uid, :string
      add_column :organizations, :stripe_access_code, :string
  end
end
