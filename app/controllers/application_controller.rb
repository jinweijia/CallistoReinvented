class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 	before_filter :configure_permitted_parameters, if: :devise_controller?

  # protected
  helper_method :resource, :resource_name, :devise_mapping

    def resource_name
      :user
    end

    def resource
      @resource ||= User.new
    end

    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :type, :company_id, :skill)}
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :current_password, :type, :skill, :company_id) }
    end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :type, :company_id, :skill)
  end

  def log_out
  end
  
end
