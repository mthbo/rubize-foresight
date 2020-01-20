class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, :redirect_unless_admin,  only: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :require_no_authentication

  protected

  def after_sign_up_path_for(resource)
    admin_users_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def redirect_unless_admin
    unless current_user.try(:admin?)
      flash[:alert] = "Only admins can do that"
      redirect_to root_path
    end
  end

  def sign_up(resource_name, resource)
    true
  end

end
