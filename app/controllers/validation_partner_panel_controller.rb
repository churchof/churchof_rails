class ValidationPartnerPanelController < ApplicationController

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :validation_partner
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

	def index
	  	@church_admins = User.with_role(:church_admin)
    	@activities = Activity.where("description like ?", "%User viewed ROSM records%")
	  	@church_admins.each do |user|
  			authorize! :read, user
  		end
	end
end
