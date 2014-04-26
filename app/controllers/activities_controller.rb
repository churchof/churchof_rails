class ActivitiesController < ApplicationController

skip_authorization_check
	def create
		klass = params[:subject_type].constantize
		subject = klass.find(params[:subject_id])

		@user = User.find(params[:user_id])
		@user.activities.create!(subject: subject, description: params[:description])

		respond_to do |format|
			format.js { head :ok }
		end
	end

end
