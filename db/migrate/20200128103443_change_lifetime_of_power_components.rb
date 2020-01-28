class ChangeLifetimeOfPowerComponents < ActiveRecord::Migration[5.2]
  def change
    change_column :power_systems, :lifetime, :integer
    change_column :batteries, :lifetime, :integer
    change_column :solar_panels, :lifetime, :integer
    change_column :communication_modules, :lifetime, :integer
    change_column :distributions, :lifetime, :integer
  end
end
