class SolarSystem < ApplicationRecord
  belongs_to :project
  belongs_to :solar_panel
  belongs_to :battery
  belongs_to :power_system, optional: true

  VOLTAGES = [24, 48]

  validates :system_voltage, inclusion: {in: VOLTAGES, allow_blank: true}, presence: true
  validates :autonomy, numericality: {greater_than_or_equal_to: 0, allow_nil: true}, presence: true
  validates :battery_id, presence: true
  validates :solar_panel_id, presence: true

  def battery_quantity
    unless battery.voltage.blank? or battery.voltage.zero? or battery.storage.blank? or battery.storage.zero?
      factor = (system_voltage / battery.voltage).to_i
      quantity = project.daily_consumption.to_f / battery.storage * autonomy
      quantity % factor == 0 ? quantity.to_i : quantity.div(factor) * factor + factor
    end
  end

  def storage_max
    if battery_quantity.present?
      battery_quantity * battery.storage_max
    end
  end

  def storage
    if battery_quantity.present?
      battery_quantity * battery.storage
    end
  end

  def solar_panel_quantity
    unless storage_max.blank? or solar_panel.power.blank? or solar_panel.power.zero?
      (storage_max.to_f / (solar_panel.power * 5)).ceil
    end
  end

  def power
    if solar_panel_quantity.present?
      solar_panel_quantity * solar_panel.power
    end
  end

end
