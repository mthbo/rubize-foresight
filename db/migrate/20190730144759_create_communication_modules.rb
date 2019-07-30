class CreateCommunicationModules < ActiveRecord::Migration[5.2]
  def change
    create_table :communication_modules do |t|
      t.integer :price_min_cents
      t.integer :price_max_cents
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
