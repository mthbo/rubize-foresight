class ProjectsController < ApplicationController
  include PowerSystemAttribution
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:public]
  layout 'form', only: [:new, :create, :edit, :update, :duplicate]

  def index
    @query = params[:query]
    if @query.present?
      @projects = policy_scope(Project).search(@query)
    else
      @projects = policy_scope(Project).ordered
    end
  end

  def show
    @project_appliances = @project.project_appliances.ordered
    @uses = @project.uses.ordered
  end

  def new
    @project = Project.new
    authorize @project
  end

  def duplicate
    @parent_project = Project.find(params[:id])
    @project = @parent_project.dup
    @project.name += " -- copy"
    authorize @project
    @project.save
    duplicate_project_appliances
    duplicate_solar_systems
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    if @project.save
      flash[:notice] = "#{@project.name} has been created"
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      update_solar_systems
      flash[:notice] = "#{@project.name} has been updated"
      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:notice] = "#{@project.name} has been deleted"
    redirect_to projects_path
  end

  def public
    @project = Project.find_by(token: params[:token])
    authorize @project
    @project_appliances = @project.project_appliances.ordered
    @uses = @project.uses.ordered
    render layout: 'public'
  end

  private

  def find_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def update_solar_systems
    @project.solar_systems.each do |solar_system|
      @solar_system = solar_system
      attribute_power_system_to_solar_system
    end
  end

  def duplicate_project_appliances
    @parent_project.project_appliances.each do |parent_project_appliance|
      project_appliance = parent_project_appliance.dup
      project_appliance.project = @project
      project_appliance.save
    end
  end

  def duplicate_solar_systems
    @parent_project.solar_systems.each do |parent_solar_system|
      solar_system = parent_solar_system.dup
      solar_system.project = @project
      solar_system.save
    end
  end

  def project_params
    params.require(:project).permit(
      :name,
      :description,
      :country_code,
      :city,
      :day_time,
      :night_time,
      :current_ac,
      :current_dc,
      :voltage_min,
      :voltage_max,
      :frequency
    )
  end
end
