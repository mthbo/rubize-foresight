class AddDailyConsumptionToCommunicationModule < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_modules, :daily_consumption, :integer
  end
end
