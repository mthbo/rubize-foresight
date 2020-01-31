class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :request_registration]

  def home
  end

  def power_components
    @power_systems = policy_scope(PowerSystem).ordered
    @solar_panels = policy_scope(SolarPanel).ordered
    @batteries = policy_scope(Battery).ordered
    @communication_modules = policy_scope(CommunicationModule).all
  end

  def request_registration
    User.where(admin: true).each do |user|
      UserMailer.with(user: user, name: params[:inputName], email: params[:inputEmail], message: params[:inputMessage]).request_registration.deliver_now
    end
    flash[:notice] = "Your message have been sent to the Rubize Foresight team!"
    redirect_to root_path
  end
end
