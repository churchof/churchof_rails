class UsersController < ApplicationController

load_and_authorize_resource

  before_filter :is_allowed_to_view_page?, only: [:new, :create, :edit, :update, :index]

  def add_user_as_full_rosm_member
    @user = User.find(params[:user][:user_id])
    @user.update_attribute(:is_full_rosm_member, true)
    @user.save
    redirect_to validation_partner_panel_index_path
  end

  def remove_user_as_full_rosm_member
    @user = User.find(params[:user][:user_id])
    @user.update_attribute(:is_full_rosm_member, false)
    @user.save
    redirect_to validation_partner_panel_index_path
  end

  def add_user_as_resource_partner
    @user = User.find(params[:user][:user_id])
    @user.add_role "resource_partner"
    @user.save
    redirect_to root_path
  end

  def remove_user_as_resource_partner
    @user = User.find(params[:user][:user_id])
    @user.remove_role "resource_partner"
    @user.save
    @user.remove_management_from_resources
    redirect_to root_path
  end

  def agree_to_need_poster_agreement
    current_user.remove_role "pending_need_poster"
    current_user.add_role "need_poster"
    current_user.save
    redirect_to need_poster_panel_index_path
  end

  def agree_to_need_leader_agreement
    current_user.remove_role "pending_need_leader"
    current_user.add_role "need_leader"
    current_user.save
    redirect_to need_leader_panel_index_path
  end

  def agree_to_church_admin_agreement
    current_user.remove_role "pending_church_admin"
    current_user.add_role "church_admin"
    current_user.save
    redirect_to church_admin_panel_index_path
  end

  def is_allowed_to_view_page?
    if current_user.has_role? :super_admin
      true
    else
      redirect_to root_path, :flash => { :alert => "You don't have permission to view that page." }
    end
  end

  def index
  	@users = User.all
    @activities = Activity.all
  end

  def show
   @user = User.find(params[:id])
  end

  def update
    # Added for the checkboxes from this tutorial: http://railscasts.com/episodes/17-habtm-checkboxes?view=comments

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