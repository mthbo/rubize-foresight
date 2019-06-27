class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  layout 'form', only: [:new, :create, :edit, :update]

  def index
    @projects = policy_scope(Project).all

    @markers = @projects.map do |project|
      {
        lat: project.latitude,
        lng: project.longitude,
        infoWindow: render_to_string(partial: "infowindow", locals: { project: project })
      }
    end
  end

  def show
  end

  def new
    @project = current_user.projects.new
    authorize @project
  end

  def create
    @project = current_user.project.new(project_params)
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
  end

  private

  def find_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:project).permit(:name, :description, :address, :latitude, :longitude)
  end
end
