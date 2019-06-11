class DropVoltageAndApllianceVOltageTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :appliance_voltages
    drop_table :voltages
  end
end
