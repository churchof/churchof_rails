class OrganizationRole < ActiveRecord::Base

		extend Enumerize

  belongs_to :organization
  belongs_to :user

	validates :organization_id, presence: true
	validates :user_id, presence: true
	validates :role_type, presence: true


# Note currently these roles are double stored... this happened from the evolution of the platform. The user has a rolify role and then this relationship... should be condensed eventually but this is needed to tell who is with what organization.
# if you add more here youll need to update the validate_organization_role method in the controller.
	enumerize :role_type, in: {:resource_manager => 1, :need_leader => 2, :church_admin => 3}, default: nil

end