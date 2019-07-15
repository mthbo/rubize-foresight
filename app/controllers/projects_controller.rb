class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  layout 'form', only: [:new, :create, :edit, :update]

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
    appliance_ids = @project_appliances.select(:appliance_id).reorder("").distinct
    @appliances = policy_scope(Appliance).where(id: appliance_ids)
    use_ids = @appliances.select(:use_id).reorder("").distinct
    @uses = policy_scope(Use).where(id: use_ids).ordered
  end

  def new
    @project = Project.new
    authorize @project
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

  private

  def find_project
    @project = Project.find(params[:id])
    authorize @project
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
