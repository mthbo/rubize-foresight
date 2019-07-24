class BatteriesController < ApplicationController
  before_action :find_battery, only: [:edit, :update, :destroy]
  layout 'form', only: [:new, :create, :edit, :update]

  def new
    @battery = Battery.new
    authorize @battery
  end

  def create
    @battery = Battery.new(battery_params)
    authorize @battery
    if @battery.save
      flash[:notice] = "A new battery has been created."
      redirect_to power_components_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @battery.update(battery_params)
      flash[:notice] = "The battery has been updated."
      redirect_to power_components_path
    else
      render :edit
    end
  end

  def destroy
    @battery.destroy
    # flash[:notice] = "The battery has been deleted"
  end

  private

  def find_battery
    @battery = Battery.find(params[:id])
    authorize @battery
  end

  def battery_params
    params.require(:battery).permit(
      :technology,
      :dod,
      :voltage,
      :capacity,
      :price,
      :currency
    )
  end
end
