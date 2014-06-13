class OrganizationRole < ActiveRecord::Base

		extend Enumerize

  belongs_to :organization
  belongs_to :user

	validates :organization_id, presence: true
	validates :user_id, presence: true


	enumerize :role_type, in: {:resource_manager => 1}, default: nil

end