class CreatePowerSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :power_systems do |t|
      t.string :name
      t.text :description
      t.integer :charge_current
      t.boolean :voltage_12
      t.boolean :voltage_24
      t.boolean :voltage_36
      t.boolean :voltage_48
      t.boolean :inverter
      t.integer :power_out
      t.integer :voltage_out_min
      t.integer :voltage_out_max
      t.boolean :communication
      t.integer :price_cents
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
