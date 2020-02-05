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
    message = "Hello Rubize team! 👋, you have received a request from *Rubize Foresight*.\n\n"\
      "*Name of the organization*\n#{params[:inputName]}\n\n"\
      "*Email*\n#{params[:inputEmail]}\n\n"\
      "*Message*\n#{params[:inputMessage]}\n\n"\
      "To manage user accounts, go to #{Rails.application.routes.url_helpers.admin_users_url}."
    SlackNotifier::CLIENT.ping(message)
    flash[:notice] = "Your message have been sent to the Rubize Foresight team!"
    redirect_to root_path
  end
end
