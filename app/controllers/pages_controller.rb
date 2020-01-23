class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :request_registration]

  def home
  end

  def power_components
    @power_systems = policy_scope(PowerSystem).ordered
    @solar_panels = policy_scope(SolarPanel).ordered
    @batteries = policy_scope(Battery).ordered
    @communication_modules = policy_scope(CommunicationModule).all
    @distributions = policy_scope(Distribution).all
  end

  def request_registration
    redirect_to root_path
  end
end
