class AddPriceRangeToSolarPanel < ActiveRecord::Migration[5.2]
  def change
    rename_column :solar_panels, :price_cents, :price_min_cents
    add_column :solar_panels, :price_max_cents, :integer
  end
end
