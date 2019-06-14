class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string :supplier
      t.date :issued_at
      t.text :details
      t.string :country_code
      t.string :city
      t.integer :amount_cents
      t.string :currency_code
      t.integer :tax_rate, default: 0
      t.references :appliance, foreign_key: true

      t.timestamps
    end
  end
end
