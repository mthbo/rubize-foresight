class RenameDailyConsumptionOfCommunicationModules < ActiveRecord::Migration[5.2]
  def change
    rename_column :communication_modules, :daily_consumption, :power
  end
end
