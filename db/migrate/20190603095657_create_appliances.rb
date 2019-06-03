class CreateAppliances < ActiveRecord::Migration[5.2]
  def change
    create_table :appliances do |t|
      t.string :name
      t.text :description
      t.integer :voltage
      t.float :power
      t.float :power_factor
      t.float :starting_coefficient

      t.timestamps
    end
  end
end
