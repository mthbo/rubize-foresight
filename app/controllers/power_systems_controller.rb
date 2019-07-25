class PowerSystemsController < ApplicationController
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
      :description,
      :charge_current,
      :voltage_12,
      :voltage_24,
      :voltage_36,
      :voltage_48,
      :inverter,
      :power_out,
      :voltage_out_min,
      :voltage_out_max,
      :communication,
      :price,
      :currency
    )
  end
end
