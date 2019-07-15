class AddQuantityToProjectAppliance < ActiveRecord::Migration[5.2]
  def change
    add_column :project_appliances, :quantity, :integer, default: 1
  end
end
