class SourcesController < ApplicationController
  before_action :find_appliance, only: [:new, :create, :update, :destroy]
  before_action :find_source, only: [:edit, :update, :destroy]

  def new
    @source = @appliance.sources.new
  end

  def create
    @source = @appliance.sources.new(source_params)
    if @source.save
      flash[:notice] = "A new source has been added to #{@appliance.name}"
      redirect_to appliance_path(@appliance)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @source.update(source_params)
      flash[:notice] = "The source has been updated"
      redirect_to appliance_path(@appliance)
    else
      render :edit
    end
  end

  def destroy
    @source.destroy
    flash[:notice] = "The source has been deleted"
    redirect_to appliance_path(@appliance)
  end

  private

  def find_appliance
    @appliance = Appliance.find(params[:appliance_id])
  end

  def find_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(
      :appliance_id,
      :supplier,
      :issued_at,
      :details,
      :country_code,
      :city,
      :amount_cents,
      :currency_code,
      :tax_rate
    )
  end
end
