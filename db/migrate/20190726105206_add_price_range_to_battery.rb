class AddPriceRangeToBattery < ActiveRecord::Migration[5.2]
  def change
    rename_column :batteries, :price_cents, :price_min_cents
    add_column :batteries, :price_max_cents, :integer
  end
end
