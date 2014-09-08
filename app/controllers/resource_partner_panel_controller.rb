class ResourcePartnerPanelController < ApplicationController

  # This is here becasue of the pending portion, the authorize! below should still work.
      skip_authorization_check

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :resource_partner
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

	def index
		resources = Array.new
		current_user.resources.each do |resource|
			resources << resource
		end
		organizations = Array.new
		resources.each do |resource|
			if resource.organization
				organizations << resource.organization
			end
		end
		current_user.organization_roles.each do |organization_role|
			organizations << organization_role.organization
		end
		@organizations = organizations.uniq

		@organizations.each do |organization|
			organization.resources.each do |resource|
				resources << resource
			end
		end
		@resources = resources.uniq

		@resources_without_organization = Array.new()
		@resources_with_organization = Array.new()

		@resources.each do |resource|
			if resource.organization
				@resources_with_organization << resource
			else
				@resources_without_organization << resource
			end

		end

	  	# @church_admins = User.with_role(:church_admin)

	  	@resources.each do |resource|
  			authorize! :read, resource
  		end
  		@resources_without_organization.each do |resource|
  			authorize! :read, resource
  		end
	  	@resources_with_organization.each do |resource|
  			authorize! :read, resource
  		end
	  	@organizations.each do |organization|
  			authorize! :read, organization
  		end
	end

end
