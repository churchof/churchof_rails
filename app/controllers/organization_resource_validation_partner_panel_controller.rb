class OrganizationResourceValidationPartnerPanelController < ApplicationController

  # This is here becasue of the pending portion, the authorize! below should still work.
      skip_authorization_check

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :organization_resource_validation_partner
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

	def index
		@organizations = Organization.all
		@users = User.all
		@organization_roles = OrganizationRole.all
		@skills = Skill.all

	  	# @church_admins = User.with_role(:church_admin)
	  	@organizations.each do |organization|
  			authorize! :manage, organization
  		end
	  	@users.each do |user|
  			authorize! :read, user
  		end
	  	@organization_roles.each do |organization_role|
  			authorize! :manage, organization_role
  		end
  		@skills.each do |skill|
  			authorize! :read, skill
  		end

	end
end
