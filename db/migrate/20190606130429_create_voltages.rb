class CreateVoltages < ActiveRecord::Migration[5.2]
  def change
    create_table :voltages do |t|
      t.integer :level
      t.timestamps
    end
    remove_column :appliances, :voltage
  end
end
