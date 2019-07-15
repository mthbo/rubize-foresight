class CreateProjectAppliances < ActiveRecord::Migration[5.2]
  def change
    create_table :project_appliances do |t|
      t.references :project, foreign_key: true
      t.references :appliance, foreign_key: true
      t.string :hourly_rate_0
      t.string :hourly_rate_1
      t.string :hourly_rate_2
      t.string :hourly_rate_3
      t.string :hourly_rate_4
      t.string :hourly_rate_5
      t.string :hourly_rate_6
      t.string :hourly_rate_7
      t.string :hourly_rate_8
      t.string :hourly_rate_9
      t.string :hourly_rate_10
      t.string :hourly_rate_11
      t.string :hourly_rate_12
      t.string :hourly_rate_13
      t.string :hourly_rate_14
      t.string :hourly_rate_15
      t.string :hourly_rate_16
      t.string :hourly_rate_17
      t.string :hourly_rate_18
      t.string :hourly_rate_19
      t.string :hourly_rate_20
      t.string :hourly_rate_21
      t.string :hourly_rate_22
      t.string :hourly_rate_23

      t.timestamps
    end
  end
end
