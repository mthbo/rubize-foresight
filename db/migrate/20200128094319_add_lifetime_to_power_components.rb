class AddLifetimeToPowerComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :power_systems, :lifetime, :float
    add_column :batteries, :lifetime, :float
    add_column :solar_panels, :lifetime, :float
    add_column :communication_modules, :lifetime, :float
    add_column :distributions, :lifetime, :float
  end
end
