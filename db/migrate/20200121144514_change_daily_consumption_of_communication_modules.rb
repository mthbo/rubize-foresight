class ChangeDailyConsumptionOfCommunicationModules < ActiveRecord::Migration[5.2]
  def change
    change_column :communication_modules, :daily_consumption, :float
  end
end
