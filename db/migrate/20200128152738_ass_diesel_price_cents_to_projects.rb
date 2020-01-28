class AssDieselPriceCentsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :diesel_price_cents, :integer
    add_column :projects, :currency, :string, default: "eur"
    add_column :projects, :diesel_price_eur_cents, :integer
  end
end
