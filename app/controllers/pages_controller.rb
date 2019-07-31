class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def power_components
    @power_systems = policy_scope(PowerSystem).all
    @solar_panels = policy_scope(SolarPanel).all
    @batteries = policy_scope(Battery).all
    @communication_modules = policy_scope(CommunicationModule).all
    @distributions = policy_scope(Distribution).all
  end
end
