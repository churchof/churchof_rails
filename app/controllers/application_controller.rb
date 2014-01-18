class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Added to make Devise work with Rails 4.
  before_filter :configure_devise_params, if: :devise_controller?

  private

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :name, :avatar, :avatar_cache, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :name, :avatar,  :remove_avatar, :avatar_cache, :email, :password, :password_confirmation, :current_password)
    end
  end
end