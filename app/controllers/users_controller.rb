class UsersController < ApplicationController
  def index
  	@users = User.all
  end

  # Maybe this is the right way? It seems I need to do an actual POST to a url with params to do this the right way.
  def assign_need_poster_role
	@user = User.find(params[:id])
	@user.add_role :need_poster
	redirect_to @user
  end

  def remove_need_poster_role
  	@user = User.find(params[:id])
  	@user.remove_role :need_poster
  	redirect_to @user
  end

  # Added... but I don't want to do the template also to make this work... and is this even
  # ok with Devise? http://stackoverflow.com/questions/5212350/making-changes-to-the-devise-user-controller-in-rails
  def update
   #edit here
  end

end