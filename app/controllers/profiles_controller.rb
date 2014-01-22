class ProfilesController < ApplicationController
  def show
  	@user = User.find_by_id(params[:id])
  	if @user
  		@needs = @user.needs.all
  		render action: :show
  	else
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end
end
