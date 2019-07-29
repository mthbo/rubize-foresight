class SolarSystemsController < ApplicationController
  include PowerSystemAttribution
  before_action :find_solar_system, only: [:edit, :update]
  before_action :find_project, only: [:new, :create]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @solar_system = @project.solar_systems.new
    authorize @solar_system
  end

  def create
    @solar_system = @project.solar_systems.new(solar_system_params)
    authorize @solar_system
    if @solar_system.save
      attribute_power_system_to_solar_system
      flash[:notice] = "A solar system has been added to the project."
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @solar_system.update(solar_system_params)
      @project = @solar_system.project
      attribute_power_system_to_solar_system
      flash[:notice] = "The solar system has been updated."
      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  private

  def find_solar_system
    @solar_system = SolarSystem.find(params[:id])
    authorize @solar_system
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def solar_system_params
    params.require(:solar_system).permit(
      :battery_id,
      :solar_panel_id,
      :system_voltage,
      :autonomy,
      :communication,
      :distribution
    )
  end
end
