class DistributionsController < ApplicationController
  before_action :find_distribution, only: [:edit, :update]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @distribution = current_user.distributions.new
    authorize @distribution
  end

  def create
    @distribution = current_user.distributions.new(distribution_params)
    authorize @distribution
    if @distribution.save
      update_solar_systems
      flash[:notice] = "A new distribution wiring has been created."
      redirect_to power_components_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @distribution.update(distribution_params)
      flash[:notice] = "The distribution wiring has been updated."
      redirect_to power_components_path
    else
      render :edit
    end
  end

  private

  def update_solar_systems
    policy_scope(Project).each do |project|
      project.solar_systems.each do |solar_system|
        solar_system.update(distribution_id: @distribution.id)
      end
    end
  end

  def find_distribution
    @distribution = Distribution.find(params[:id])
    authorize @distribution
  end

  def distribution_params
    params.require(:distribution).permit(
      :price_min,
      :price_max,
      :currency
    )
  end
end
