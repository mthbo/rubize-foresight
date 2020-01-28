class AddGridElectricityChargesToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :grid_connection_charge_cents, :integer
    add_column :projects, :grid_subscription_charge_cents, :integer
    add_column :projects, :grid_consumption_charge_cents, :integer
    add_column :projects, :grid_connection_charge_eur_cents, :integer
    add_column :projects, :grid_subscription_charge_eur_cents, :integer
    add_column :projects, :grid_consumption_charge_eur_cents, :integer
  end
end
