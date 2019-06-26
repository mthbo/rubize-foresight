class UsesController < ApplicationController
  before_action :find_use, only: [:edit, :update, :destroy]
  before_action :all_uses, only: [:new, :create, :edit, :update]

  def new
    @use = Use.new
    authorize @use
  end

  def create
    @use = Use.new(use_params)
    authorize @use
    if @use.save
      flash[:notice] = "#{@use.name} has been created"
      redirect_to appliances_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @use.update(use_params)
      flash[:notice] = "#{@use.name} has been updated"
      redirect_to appliances_path
    else
      render :edit
    end
  end

  def destroy
    @use.destroy
    flash[:notice] = "#{@use.name} has been deleted"
  end

  private

  def all_uses
    @uses = policy_scope(Use)
  end

  def find_use
    @use = Use.find(params[:id])
    authorize @use
  end

  def use_params
    params.require(:use).permit(
      :name,
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
