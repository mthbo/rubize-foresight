class AddEnergyGradeToAppliance < ActiveRecord::Migration[5.2]
  def change
    add_column :appliances, :energy_grade, :string
  end
end
