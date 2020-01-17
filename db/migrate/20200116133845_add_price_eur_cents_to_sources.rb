class AddPriceEurCentsToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :price_eur_cents, :integer
  end
end
