class ImpactPanelController < ApplicationController

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if user_signed_in?
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

  def index

    @needs = Array.new

	current_user.contributions.each do |contribution|
		if contribution.need.is_public
			@needs << contribution.need
		end
	end
  	@needs_supported = @needs.uniq
  end
end
