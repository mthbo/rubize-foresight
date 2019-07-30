class CreateDistributions < ActiveRecord::Migration[5.2]
  def change
    create_table :distributions do |t|
      t.integer :price_min_cents
      t.integer :price_max_cents
      t.string :currency, default: 'eur'

      t.timestamps
    end
  end
end
