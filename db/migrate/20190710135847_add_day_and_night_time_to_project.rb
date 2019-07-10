class AddDayAndNightTimeToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :day_time, :time
    add_column :projects, :night_time, :time
  end
end
