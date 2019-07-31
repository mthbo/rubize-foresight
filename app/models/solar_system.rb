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

  monetize :batteries_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :batteries_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :solar_panels_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :solar_panels_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :power_system_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :power_system_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :communication_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :communication_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :distribution_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :distribution_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :price_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_max_cents, allow_nil: true, with_currency: :eur

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

  def power_system_price_min_cents
    if power_system.present? and power_system.price_min_eur_cents.present?
      power_system.price_min_eur_cents
    end
  end

  def power_system_price_max_cents
    if power_system.present? and power_system.price_max_eur_cents.present?
      power_system.price_max_eur_cents
    end
  end

  def batteries_price_min_cents
    if power_system.present? and battery.price_min_eur_cents.present? and battery_quantity.present?
      battery.price_min_eur_cents * battery_quantity
    end
  end

  def batteries_price_max_cents
    if power_system.present? and battery.price_max_eur_cents.present? and battery_quantity.present?
      battery.price_max_eur_cents * battery_quantity
    end
  end

  def solar_panels_price_min_cents
    if power_system.present? and solar_panel.price_min_eur_cents.present? and solar_panel_quantity.present?
      solar_panel.price_min_eur_cents * solar_panel_quantity
    end
  end

  def solar_panels_price_max_cents
    if power_system.present? and solar_panel.price_max_eur_cents.present? and solar_panel_quantity.present?
      solar_panel.price_max_eur_cents * solar_panel_quantity
    end
  end

  def communication_price_min_cents
    if power_system.present?
      (communication? and CommunicationModule.first.present?) ? CommunicationModule.first.price_min_eur_cents : 0
    end
  end

  def communication_price_max_cents
    if power_system.present?
      (communication? and CommunicationModule.first.present?) ? CommunicationModule.first.price_max_eur_cents : 0
    end
  end

  def distribution_price_min_cents
    if power_system.present?
      (distribution? and Distribution.first.present?) ? Distribution.first.price_min_eur_cents * project.appliance_quantity : 0
    end
  end

  def distribution_price_max_cents
    if power_system.present?
      (distribution? and Distribution.first.present?) ? Distribution.first.price_max_eur_cents * project.appliance_quantity : 0
    end
  end

  def price_min_cents
    if batteries_price_min_cents.present? and solar_panels_price_min_cents.present? and power_system_price_min_cents.present?
      batteries_price_min_cents + solar_panels_price_min_cents + power_system_price_min_cents + communication_price_min_cents + distribution_price_min_cents
    end
  end

  def price_max_cents
    if batteries_price_max_cents.present? and solar_panels_price_max_cents.present? and power_system_price_max_cents.present?
      batteries_price_max_cents + solar_panels_price_max_cents + power_system_price_max_cents + communication_price_max_cents + distribution_price_max_cents
    end
  end

end
