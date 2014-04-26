class NeedPosterPanelController < ApplicationController

  # This is here becasue of the pending portion, the authorize! below should still work.
      skip_authorization_check

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if current_user.has_role? :need_poster
	      	true
	    elsif current_user.has_role? :pending_need_poster
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

  def index

    if current_user.has_role? :need_poster
          # this is being served up on the poster agreement page also... is this an issue?
      @needs_admin_incoming = Need.where(user_posted_by: current_user, need_stage: 1)
      @needs_admin_in_progress = Need.where(user_posted_by: current_user, need_stage: 2)
      @needs_admin_completed = Need.where(user_posted_by: current_user, need_stage: 3)

      @needs_admin_incoming.each do |need|
        authorize! :read, need
      end

      @needs_admin_in_progress.each do |need|
        authorize! :read, need
      end

      @needs_admin_completed.each do |need|
        authorize! :read, need
      end

    else
    end


  end
end
