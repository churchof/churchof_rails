class UsersController < ApplicationController
  def index
  	@users = User.all
  end

  # Maybe this is the right way? It seems I need to do an actual POST to a url with params to do this the right way.
  def assign_poster_role
	@user = User.find(params[:id])
	@user.add_role :poster
	redirect_to @user
  end

  def remove_poster_role
  	@user = User.find(params[:id])
  	@user.remove_role :poster
  	redirect_to @user
  end
end
