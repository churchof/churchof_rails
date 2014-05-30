class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Added to make Devise work with Rails 4.
  before_action :configure_devise_params, if: :devise_controller?
  before_action :cancan_parameter_sanitizer

  # Added for cancan. Currently causing too many side errors.
  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert =>  [exception.message, exception.subject, exception.action].join(' ')
  end

  respond_to :html

  private

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:skill_tokens, :first_name, :last_name, :name, :avatar, :avatar_cache, :email, :password, :password_confirmation, {:skill_ids => []})
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:skill_tokens, :first_name, :last_name, :name, :avatar, :remove_avatar, :avatar_cache, :email, :password, :password_confirmation, :current_password, {:skill_ids => []})
    end
  end

  # Part of a workaround for cancan described here: https://github.com/ryanb/cancan/issues/835
  def cancan_parameter_sanitizer
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

end