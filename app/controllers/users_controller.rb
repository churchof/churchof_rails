class UsersController < ApplicationController

  before_filter :is_allowed_to_view_page?

  def is_allowed_to_view_page?
    if current_user.has_role? :super_admin
      true
    else
      redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
    end
  end

  def index
  	@users = User.all
  end

  def update
   @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to :back, notice: 'User was successfully updated.'
    else
      render action: 'index'
      redirect_to :back, notice: 'User could not be updated.'
    end
  end

  private
    def user_params
      params.require(:user).permit!
    end
end