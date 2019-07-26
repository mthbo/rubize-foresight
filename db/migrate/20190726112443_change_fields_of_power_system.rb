class ChangeFieldsOfPowerSystem < ActiveRecord::Migration[5.2]
  def change
    remove_column :power_systems, :description
    remove_column :power_systems, :charge_current
    remove_column :power_systems, :voltage_12
    remove_column :power_systems, :voltage_24
    remove_column :power_systems, :voltage_36
    remove_column :power_systems, :voltage_48
    remove_column :power_systems, :communication

    rename_column :power_systems, :price_cents, :price_min_cents
    add_column :power_systems, :price_max_cents, :integer

    rename_column :power_systems, :power_out, :power_out_max

    rename_column :power_systems, :inverter, :ac_out
    add_column :power_systems, :dc_out, :boolean

    add_column :power_systems, :mppt, :string
    add_column :power_systems, :inverter, :string
    add_column :power_systems, :system_voltage, :integer
    add_column :power_systems, :power_in_min, :integer
    add_column :power_systems, :power_in_max, :integer
  end
end
