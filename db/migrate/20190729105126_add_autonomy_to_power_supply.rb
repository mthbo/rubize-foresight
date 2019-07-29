class AddAutonomyToPowerSupply < ActiveRecord::Migration[5.2]
  def change
    add_column :power_supplies, :autonomy, :float, default: 1
  end
end
