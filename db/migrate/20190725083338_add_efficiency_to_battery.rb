class AddEfficiencyToBattery < ActiveRecord::Migration[5.2]
  def change
    add_column :batteries, :efficiency, :integer
  end
end
