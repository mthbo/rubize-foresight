class AddFieldsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :supply_mode, :string
    add_column :projects, :supply_current_type, :string
    add_column :projects, :supply_voltage, :integer
    add_column :projects, :load_current_type, :string
    add_column :projects, :load_voltage_min, :integer
    add_column :projects, :load_voltage_max, :integer
    add_column :projects, :frequency, :string
    add_column :projects, :solar_panel_power, :string
    add_column :projects, :battery_technology, :string
    add_column :projects, :battery_voltage, :string
    add_column :projects, :battery_capacity, :string
    add_column :projects, :distribution, :boolean
  end
end
