class NeedPosterPanelController < ApplicationController

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :need_poster
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

  def index
  	@needs_admin_incoming = Need.where(user_posted_by: current_user, need_stage: 1)
  	@needs_admin_in_progress = Need.where(user_posted_by: current_user, need_stage: 2)
  	@needs_admin_completed = Need.where(user_posted_by: current_user, need_stage: 3)
  end
end
