class RemoveDcOutOfPowerSystem < ActiveRecord::Migration[5.2]
  def change
    remove_column :power_systems, :dc_out
  end
end
