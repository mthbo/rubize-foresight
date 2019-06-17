class RemoveTaxRateOfSources < ActiveRecord::Migration[5.2]
  def change
    remove_column :sources, :tax_rate
  end
end
