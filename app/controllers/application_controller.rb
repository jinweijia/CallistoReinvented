class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

 	before_filter :configure_permitted_parameters, if: :devise_controller?

  # protected
  helper_method :resource, :resource_name, :devise_mapping

  def after_sign_in_path_for(resource)
    # profile_index_path
    if current_user.type == 'Student'
      count = current_user.sign_in_count
      if count == 1
        current_user.update(sign_in_count: count+1)
        user_initialize_tags_path
      else
        profile_index_path
      end
    else current_user.type == 'Employer'
      if current_user.company_name == ''
        new_company_path
      else
        dashboard_path
      end
    # else
    #   company_path+"/"+current_user.company_name
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :type, :company_name, :skill)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :current_password, :type, :skill, :company_name)
  end

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
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :type, :company_name, :skill)}
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :current_password, :type, :skill, :company_name) }
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :type, :company_name, :skill)
  end

  def log_out
  end
end
