class ImpactPanelController < ApplicationController

      skip_authorization_check

	before_filter :is_allowed_to_view_page?

	def is_allowed_to_view_page?
	    if user_signed_in?
	      	true
	    else
	      	redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
	    end
	end

  def index
    needs = Array.new

    all_type_contributions = Array.new

	current_user.contributions.succeded.not_reimbursed.reverse.each do |contribution|
		all_type_contributions << contribution
	end

	current_user.time_contributions.reverse.each do |time_contribution|
		all_type_contributions << time_contribution
	end

	all_type_contributions = all_type_contributions.uniq.sort_by! {|obj| obj.created_at unless obj.blank?}

	all_type_contributions.reverse.each do |contribution_type|
		#if contribution.need.is_public == true
			needs << contribution_type.need
		#end
	end

  	@needs_supported = needs.uniq


  	current_user.time_contributions.each do |time_contribution|
  		authorize! :read, time_contribution
  	end

  	current_user.contributions.each do |contribution|
  		authorize! :read, contribution
  	end

  	@needs_supported.each do |need|
  		authorize! :read, need
  	end

  end
end
