class UsesController < ApplicationController
  before_action :find_use, only: [:edit, :update, :destroy]
  before_action :all_uses, only: [:new, :edit]

  def new
    @use = Use.new
  end

  def create
    @use = Use.new(use_params)
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
    redirect_to appliances_path
  end

  private

  def all_uses
    @uses = Use.all
  end

  def find_use
    @use = Use.find(params[:id])
  end

  def use_params
    params.require(:use).permit(:name)
  end
end
