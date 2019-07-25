class AddVoltageToSolarPanel < ActiveRecord::Migration[5.2]
  def change
    add_column :solar_panels, :voltage, :integer
  end
end
