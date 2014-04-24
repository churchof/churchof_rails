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


    # hash thing... loop over deal... so you can still show all but NEED GONE WHERE NEEDED

	current_user.contributions.succeded.not_reimbursed.reverse.each do |contribution|
		#if contribution.need.is_public == true
			@needs << contribution.need
		#end
	end
  	@needs_supported = @needs.uniq
  end
end
