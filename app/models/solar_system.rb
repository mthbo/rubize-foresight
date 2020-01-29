class SolarSystem < ApplicationRecord
  belongs_to :project
  belongs_to :solar_panel
  belongs_to :battery
  belongs_to :communication_module, optional: true
  belongs_to :distribution, optional: true
  belongs_to :power_system, optional: true

  include Discounting

  VOLTAGES = [24, 48]
  PV_COEFF = 5.5
  O_AND_M_COST_RATIO = 0.015

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
  monetize :lcoe_min_cents, allow_nil: true, with_currency: :eur
  monetize :lcoe_max_cents, allow_nil: true, with_currency: :eur

  def project_daily_consumption
    sum = project.daily_consumption
    sum += communication_module.daily_consumption if communication? and communication_module.present?
    sum
  end

  def project_yearly_consumption
    (project_daily_consumption * 365).to_f / 1000 if project_daily_consumption
  end

  def communication_module_consumption
    if communication? and communication_module.present?
      communication_module.daily_consumption
    else
      0
    end
  end

  def battery_quantity
    unless battery.voltage.blank? or battery.voltage.zero? or battery.storage.blank? or battery.storage.zero?
      factor = (system_voltage / battery.voltage).to_i
      quantity = project_daily_consumption.to_f / battery.storage * autonomy
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
    unless storage_max.blank? or solar_panel.power.blank? or solar_panel.power.zero? or battery.efficiency.blank? or battery.efficiency.zero?
      min_pv_power = storage_max.to_f / (PV_COEFF * battery.efficiency) * 100
      (min_pv_power.to_f / solar_panel.power).ceil
    end
  end

  def power
    if solar_panel_quantity.present?
      solar_panel_quantity * solar_panel.power
    end
  end

  # Prices

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
    if power_system.present? and communication? and communication_module.present? and communication_module.price_min_eur_cents
      communication_module.price_min_eur_cents
    end
  end

  def communication_price_max_cents
    if power_system.present? and communication? and communication_module.present? and communication_module.price_max_eur_cents
      communication_module.price_max_eur_cents
    end
  end

  def distribution_price_min_cents
    if power_system.present? and wiring? and distribution.present? and distribution.price_min_eur_cents
      distribution.price_min_eur_cents * project.appliance_quantity
    end
  end

  def distribution_price_max_cents
    if power_system.present? and wiring? and distribution.present? and distribution.price_max_eur_cents
      distribution.price_max_eur_cents * project.appliance_quantity
    end
  end

  def price_min_cents
    price = 0
    price += batteries_price_min_cents if batteries_price_min_cents
    price += solar_panels_price_min_cents if solar_panels_price_min_cents
    price += power_system_price_min_cents if power_system_price_min_cents
    price += communication_price_min_cents if communication_price_min_cents
    price += distribution_price_min_cents if distribution_price_min_cents
    price
  end

  def price_max_cents
    price = 0
    price += batteries_price_max_cents if batteries_price_max_cents
    price += solar_panels_price_max_cents if solar_panels_price_max_cents
    price += power_system_price_max_cents if power_system_price_max_cents
    price += communication_price_max_cents if communication_price_max_cents
    price += distribution_price_max_cents if distribution_price_max_cents
    price
  end

  # LCOE Calculation

  def power_system_capex_discounted_min_cents
    if power_system_price_min_cents and power_system.lifetime
      capex_discounted(power_system_price_min_cents, power_system.lifetime)
    end
  end

  def power_system_capex_discounted_max_cents
    if power_system_price_max_cents and power_system.lifetime
      capex_discounted(power_system_price_max_cents, power_system.lifetime)
    end
  end

  def batteries_capex_discounted_min_cents
    if batteries_price_min_cents and battery.lifetime
      capex_discounted(batteries_price_min_cents, battery.lifetime)
    end
  end

  def batteries_capex_discounted_max_cents
    if batteries_price_max_cents and battery.lifetime
      capex_discounted(batteries_price_max_cents, battery.lifetime)
    end
  end

  def solar_panels_capex_discounted_min_cents
    if solar_panels_price_min_cents and solar_panel.lifetime
      capex_discounted(solar_panels_price_min_cents, solar_panel.lifetime)
    end
  end

  def solar_panels_capex_discounted_max_cents
    if solar_panels_price_max_cents and solar_panel.lifetime
      capex_discounted(solar_panels_price_max_cents, solar_panel.lifetime)
    end
  end

  def communication_capex_discounted_min_cents
    if communication_price_min_cents and communication_module.lifetime
      capex_discounted(communication_price_min_cents, communication_module.lifetime)
    end
  end

  def communication_capex_discounted_max_cents
    if communication_price_max_cents and communication_module.lifetime
      capex_discounted(communication_price_max_cents, communication_module.lifetime)
    end
  end

  def distribution_capex_discounted_min_cents
    if distribution_price_min_cents and distribution.lifetime
      capex_discounted(distribution_price_min_cents, distribution.lifetime)
    end
  end

  def distribution_capex_discounted_max_cents
    if distribution_price_max_cents and distribution.lifetime
      capex_discounted(distribution_price_max_cents, distribution.lifetime)
    end
  end

  def opex_discounted_min_cents
    if price_min_cents
      opex_discounted(price_min_cents * O_AND_M_COST_RATIO)
    end
  end

  def opex_discounted_max_cents
    if price_max_cents
      opex_discounted(price_max_cents * O_AND_M_COST_RATIO)
    end
  end

  def project_consumption_discounted
    if project_yearly_consumption
      energy_discounted(project_yearly_consumption)
    end
  end

  def lcoe_min_cents
    unless project_consumption_discounted.blank? or project_consumption_discounted.zero? or power_system_capex_discounted_min_cents.blank?
      totex_discounted = 0
      totex_discounted += power_system_capex_discounted_min_cents if power_system_capex_discounted_min_cents
      totex_discounted += batteries_capex_discounted_min_cents if batteries_capex_discounted_min_cents
      totex_discounted += solar_panels_capex_discounted_min_cents if solar_panels_capex_discounted_min_cents
      totex_discounted += communication_capex_discounted_min_cents if communication_capex_discounted_min_cents
      totex_discounted += distribution_capex_discounted_min_cents if distribution_capex_discounted_min_cents
      totex_discounted += opex_discounted_min_cents if opex_discounted_min_cents
      (totex_discounted / project_consumption_discounted)
    end
  end

  def lcoe_max_cents
    unless project_consumption_discounted.blank? or project_consumption_discounted.zero? or power_system_capex_discounted_max_cents.blank?
      totex_discounted = 0
      totex_discounted += power_system_capex_discounted_max_cents if power_system_capex_discounted_max_cents
      totex_discounted += batteries_capex_discounted_max_cents if batteries_capex_discounted_max_cents
      totex_discounted += solar_panels_capex_discounted_max_cents if solar_panels_capex_discounted_max_cents
      totex_discounted += communication_capex_discounted_max_cents if communication_capex_discounted_max_cents
      totex_discounted += distribution_capex_discounted_max_cents if distribution_capex_discounted_max_cents
      totex_discounted += opex_discounted_max_cents if opex_discounted_max_cents
      (totex_discounted / project_consumption_discounted)
    end
  end
end
