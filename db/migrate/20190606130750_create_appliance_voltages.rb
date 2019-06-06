class CreateApplianceVoltages < ActiveRecord::Migration[5.2]
  def change
    create_table :appliance_voltages do |t|
      t.references :voltage, foreign_key: true
      t.references :appliance, foreign_key: true
      t.timestamps
    end
  end
end
