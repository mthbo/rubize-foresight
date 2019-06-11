class AddVoltageAndFrequencyToAppliance < ActiveRecord::Migration[5.2]
  def change
    add_column :appliances, :voltage_min, :integer
    add_column :appliances, :voltage_max, :integer
    add_column :appliances, :frequency_fifty_hz, :boolean
    add_column :appliances, :frequency_sixty_hz, :boolean
  end
end
