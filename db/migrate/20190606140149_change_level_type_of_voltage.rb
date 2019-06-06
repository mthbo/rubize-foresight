class ChangeLevelTypeOfVoltage < ActiveRecord::Migration[5.2]
  def change
    change_column :voltages, :level, :string
  end
end
