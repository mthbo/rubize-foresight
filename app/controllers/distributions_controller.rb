class DistributionsController < ApplicationController
  before_action :find_distribution, only: [:edit, :update]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @distribution = Distribution.new
    authorize @distribution
  end

  def create
    @distribution = Distribution.new(distribution_params)
    authorize @distribution
    if @distribution.save
      flash[:notice] = "A new electrical distribution has been created."
      redirect_to power_components_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @distribution.update(distribution_params)
      flash[:notice] = "The electrical distribution has been updated."
      redirect_to power_components_path
    else
      render :edit
    end
  end

  private

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
