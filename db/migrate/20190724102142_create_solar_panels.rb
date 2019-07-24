class CreateSolarPanels < ActiveRecord::Migration[5.2]
  def change
    create_table :solar_panels do |t|
      t.integer :power
      t.integer :price_cents
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
