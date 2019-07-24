class CreatePowerSupplies < ActiveRecord::Migration[5.2]
  def change
    create_table :power_supplies do |t|
      t.references :project, foreign_key: true
      t.references :solar_panel, foreign_key: true
      t.references :battery, foreign_key: true
      t.references :power_system, foreign_key: true
      t.integer :system_voltage
      t.boolean :communication
      t.boolean :distribution

      t.timestamps
    end
  end
end
