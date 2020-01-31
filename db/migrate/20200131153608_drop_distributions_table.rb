class DropDistributionsTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :solar_systems, :distribution_id
    remove_column :solar_systems, :wiring
    drop_table :distributions
  end
end
