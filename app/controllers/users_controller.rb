class UsersController < ApplicationController
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