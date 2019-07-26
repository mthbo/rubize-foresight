class RemoveVoltageOfSolarPanel < ActiveRecord::Migration[5.2]
  def change
    remove_column :solar_panels, :voltage
  end
end
