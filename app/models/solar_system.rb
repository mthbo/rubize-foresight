class SolarSystem < ApplicationRecord
  belongs_to :project
  belongs_to :solar_panel
  belongs_to :battery
  belongs_to :power_system

  VOLTAGES = [24, 48]

  validates :system_voltage, inclusion: {in: VOLTAGES, allow_blank: true}, presence: true
  validates :autonomy, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :battery_id, presence: true
  validates :solar_panel_id, presence: true

end
