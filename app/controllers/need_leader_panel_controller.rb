class NeedLeaderPanelController < ApplicationController

  # This is here becasue of the pending portion, the authorize! below should still work.
      skip_authorization_check

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :need_leader
	      	true
	    elsif current_user.has_role? :pending_need_leader
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

  def index
  	@needs_admin_in_progress = Need.where(user_need_leader: current_user, need_stage: 2)
  	@needs_admin_completed = Need.where(user_need_leader: current_user, need_stage: 3)

  	@needs_admin_in_progress.each do |need|
  		authorize! :read, need
  	end
  	@needs_admin_completed.each do |need|
  		authorize! :read, need
  	end
  end
end
