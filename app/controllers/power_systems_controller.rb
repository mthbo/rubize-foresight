class PowerSystemsController < ApplicationController
  include PowerSystemAttribution
  before_action :find_power_system, only: [:edit, :update, :destroy]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @power_system = PowerSystem.new
    authorize @power_system
  end

  def create
    @power_system = PowerSystem.new(power_system_params)
    authorize @power_system
    if @power_system.save
      flash[:notice] = "A new power system has been created."
      redirect_to power_components_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @power_system.update(power_system_params)
      @power_system.solar_systems.each do |solar_system|
        @project = solar_system.project
        @solar_system = solar_system
        attribute_power_system_to_solar_system
      end
      flash[:notice] = "The power system has been updated."
      redirect_to power_components_path
    else
      render :edit
    end
  end

  def destroy
    @power_system.destroy
    @power_systems = policy_scope(PowerSystem).all
    # flash[:notice] = "The power system has been deleted"
  end

  private

  def find_power_system
    @power_system = PowerSystem.find(params[:id])
    authorize @power_system
  end

  def power_system_params
    params.require(:power_system).permit(
      :name,
      :mppt,
      :inverter,
      :system_voltage,
      :power_in_min,
      :power_in_max,
      :ac_out,
      :power_out_max,
      :voltage_out_min,
      :voltage_out_max,
      :price_min,
      :price_max,
      :currency
    )
  end
end
