class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def power_components
    @power_systems = policy_scope(PowerSystem).all
    @solar_panels = policy_scope(SolarPanel).all
    @batteries = policy_scope(Battery).all
  end
end
