class UsesController < ApplicationController

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

  private

  def use_params
    params.require(:use).permit(:name)
  end
end
