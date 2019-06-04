class AppliancesController < ApplicationController
  before_action :find_appliance, only: [:show, :edit, :update, :destroy]

  def index
    @appliances = Appliance.all
  end

  def show
  end

  def new
    @appliance = current_user.appliances.new
  end

  def create
    @appliance = current_user.appliances.new(appliance_params)
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
  end

  private

  def find_appliance
    @appliance = Appliance.find(params[:id])
  end

  def appliance_params
    params.require(:appliance).permit(
      :name,
      :description,
      :current_type,
      :voltage,
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
