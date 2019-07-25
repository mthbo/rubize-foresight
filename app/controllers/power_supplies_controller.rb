class PowerSuppliesController < ApplicationController
  before_action :find_power_supply, only: [:edit, :update]
  before_action :find_project, only: [:new, :create]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @power_supply = @project.power_supplies.new
    authorize @power_supply
  end

  def create
    @power_supply = @project.power_supplies.new(power_supply_params)
    authorize @power_supply
    if @power_supply.save
      flash[:notice] = "A power supply setup has been added to the project."
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @power_supply.update(power_supply_params)
      flash[:notice] = "The power supply setup has been updated."
      redirect_to project_path(@power_supply.project)
    else
      render :edit
    end
  end

  private

  def find_power_supply
    @power_supply = PowerSupply.find(params[:id])
    authorize @power_supply
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def power_supply_params
    params.require(:power_system).permit(
      :battery_id,
      :solar_panel_id,
      :power_system_id,
      :system_voltage,
      :communication,
      :distribution
    )
  end
end
