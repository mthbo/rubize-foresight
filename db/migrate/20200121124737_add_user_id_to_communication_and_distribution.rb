class AddUserIdToCommunicationAndDistribution < ActiveRecord::Migration[5.2]
  def change
    rename_column :solar_systems, :distribution, :wiring
    add_reference :solar_systems, :communication_module, foreign_key: true
    add_reference :solar_systems, :distribution, foreign_key: true
  end
end
