class ChangeFieldsOfProject < ActiveRecord::Migration[5.2]
  def change
    rename_column :projects, :load_current_type, :current_type
    rename_column :projects, :load_voltage_min, :voltage_min
    rename_column :projects, :load_voltage_max, :voltage_max

    remove_column :projects, :solar_panel_power
    remove_column :projects, :battery_technology
    remove_column :projects, :battery_voltage
    remove_column :projects, :battery_capacity
    remove_column :projects, :distribution
    remove_column :projects, :supply_mode
    remove_column :projects, :supply_current_type
    remove_column :projects, :supply_voltage
  end
end
