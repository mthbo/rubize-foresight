class AddPriceEurCentsToPowerComponents < ActiveRecord::Migration[5.2]
  def change
    add_column :batteries, :price_min_eur_cents, :integer
    add_column :batteries, :price_max_eur_cents, :integer
    add_column :communication_modules, :price_min_eur_cents, :integer
    add_column :communication_modules, :price_max_eur_cents, :integer
    add_column :distributions, :price_min_eur_cents, :integer
    add_column :distributions, :price_max_eur_cents, :integer
    add_column :power_systems, :price_min_eur_cents, :integer
    add_column :power_systems, :price_max_eur_cents, :integer
    add_column :solar_panels, :price_min_eur_cents, :integer
    add_column :solar_panels, :price_max_eur_cents, :integer
  end
end
