class ChangeDefaultValueOfHourlyRatesOfAppliances < ActiveRecord::Migration[5.2]
  def change
    change_column :appliances, :hourly_rate_0, :string, default: nil
    change_column :appliances, :hourly_rate_1, :string, default: nil
    change_column :appliances, :hourly_rate_2, :string, default: nil
    change_column :appliances, :hourly_rate_3, :string, default: nil
    change_column :appliances, :hourly_rate_4, :string, default: nil
    change_column :appliances, :hourly_rate_5, :string, default: nil
    change_column :appliances, :hourly_rate_6, :string, default: nil
    change_column :appliances, :hourly_rate_7, :string, default: nil
    change_column :appliances, :hourly_rate_8, :string, default: nil
    change_column :appliances, :hourly_rate_9, :string, default: nil
    change_column :appliances, :hourly_rate_10, :string, default: nil
    change_column :appliances, :hourly_rate_11, :string, default: nil
    change_column :appliances, :hourly_rate_12, :string, default: nil
    change_column :appliances, :hourly_rate_13, :string, default: nil
    change_column :appliances, :hourly_rate_14, :string, default: nil
    change_column :appliances, :hourly_rate_15, :string, default: nil
    change_column :appliances, :hourly_rate_16, :string, default: nil
    change_column :appliances, :hourly_rate_17, :string, default: nil
    change_column :appliances, :hourly_rate_18, :string, default: nil
    change_column :appliances, :hourly_rate_19, :string, default: nil
    change_column :appliances, :hourly_rate_20, :string, default: nil
    change_column :appliances, :hourly_rate_21, :string, default: nil
    change_column :appliances, :hourly_rate_22, :string, default: nil
    change_column :appliances, :hourly_rate_23, :string, default: nil
  end
end
