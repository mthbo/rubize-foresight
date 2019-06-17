class AddDiscountRateToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :discount_rate, :integer, default: 0
  end
end
