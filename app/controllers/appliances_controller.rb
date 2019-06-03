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
    params.require(:appliance).permit(:name, :description, :voltage, :power, :power_factor, :starting_coefficient)
  end
end
