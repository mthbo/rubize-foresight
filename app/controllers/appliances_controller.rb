class AppliancesController < ApplicationController
  before_action :find_appliance, only: [:show, :edit, :update, :destroy]

  def index
    @uses = Use.ordered
  end

  def show
    @sources = @appliance.sources.ordered
  end

  def new
    @appliance = Appliance.new
    @appliance.use_id = appliance_params[:use_id]
  end

  def create
    @appliance = Appliance.new(appliance_params)
    if @appliance.save
      flash[:notice] = "#{@appliance.name} has been created"
      redirect_to appliance_path(@appliance)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @appliance.update(appliance_params)
      flash[:notice] = "#{@appliance.name} has been updated"
      redirect_to appliance_path(@appliance)
    else
      render :edit
    end
  end

  def destroy
    @appliance.destroy
    flash[:notice] = "#{@appliance.name} has been deleted"
    redirect_to appliances_path
  end

  def refresh_load
    @use = Use.find(params[:use_id])
  end

  private

  def find_appliance
    @appliance = Appliance.find(params[:id])
  end

  def appliance_params
    params.require(:appliance).permit(
      :use_id,
      :name,
      :description,
      :current_type,
      :energy_grade,
      :voltage_min,
      :voltage_max,
      :frequency_fifty_hz,
      :frequency_sixty_hz,
      :power,
      :power_factor,
      :starting_coefficient,
      :photo,
      :hourly_rate_0,
      :hourly_rate_1,
      :hourly_rate_2,
      :hourly_rate_3,
      :hourly_rate_4,
      :hourly_rate_5,
      :hourly_rate_6,
      :hourly_rate_7,
      :hourly_rate_8,
      :hourly_rate_9,
      :hourly_rate_10,
      :hourly_rate_11,
      :hourly_rate_12,
      :hourly_rate_13,
      :hourly_rate_14,
      :hourly_rate_15,
      :hourly_rate_16,
      :hourly_rate_17,
      :hourly_rate_18,
      :hourly_rate_19,
      :hourly_rate_20,
      :hourly_rate_21,
      :hourly_rate_22,
      :hourly_rate_23
    )
  end
end
