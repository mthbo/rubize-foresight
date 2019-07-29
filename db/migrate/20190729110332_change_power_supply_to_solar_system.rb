class ChangePowerSupplyToSolarSystem < ActiveRecord::Migration[5.2]
  def change
    rename_table :power_supplies, :solar_systems
  end
end
