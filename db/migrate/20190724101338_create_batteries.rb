class CreateBatteries < ActiveRecord::Migration[5.2]
  def change
    create_table :batteries do |t|
      t.string :technology
      t.integer :dod
      t.integer :voltage
      t.integer :capacity
      t.integer :price_cents
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
