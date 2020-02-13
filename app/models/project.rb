class Project < ApplicationRecord
  belongs_to :user
  has_many :project_appliances, dependent: :destroy
  has_many :appliances, -> { distinct }, through: :project_appliances
  has_many :uses, -> { distinct }, through: :appliances
  has_many :solar_systems, dependent: :destroy

  scope :ordered, -> { order(updated_at: :desc) }
  before_save :generate_unique_token
  before_save :set_prices_in_eur

  include Discounting

  include PgSearch::Model
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: true
      }
    },
    order_within_rank: "updated_at DESC"

  FREQUENCIES = ["50 Hz", "60 Hz"]
  WIRING = {
    price_min_per_appliance_eur: 50,
    price_max_per_appliance_eur: 100,
  }
  GENSET = {
    price_per_kva_eur: 850,
    o_and_m_cost_ratio: 0.1,
    efficiency: 0.28,
    lhv: 9.94,
    lifetime: 10
  }

  validates :name, presence: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :day_time, presence: true
  validates :night_time, presence: true
  validates :voltage_min, numericality: {greater_than_or_equal_to: 0, allow_nil: true}
  validates :voltage_max, numericality: {greater_than: 0, allow_nil: true}
  validates :frequency, inclusion: {in: FREQUENCIES, allow_blank: true}
  validate :select_at_least_one_current_type

  monetize :wiring_price_min_cents, allow_nil: true, with_currency: :eur
  monetize :wiring_price_max_cents, allow_nil: true, with_currency: :eur
  monetize :price_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_max_cents, allow_nil: true, with_currency: :eur
  monetize :grid_connection_charge_cents, allow_nil: true, with_model_currency: :currency
  monetize :grid_subscription_charge_cents, allow_nil: true, with_model_currency: :currency
  monetize :grid_consumption_charge_cents, allow_nil: true, with_model_currency: :currency
  monetize :grid_connection_charge_eur_cents, allow_nil: true, with_currency: :eur
  monetize :grid_subscription_charge_eur_cents, allow_nil: true, with_currency: :eur
  monetize :grid_consumption_charge_eur_cents, allow_nil: true, with_currency: :eur
  monetize :diesel_price_cents, allow_nil: true, with_model_currency: :currency
  monetize :diesel_price_eur_cents, allow_nil: true, with_currency: :eur
  monetize :genset_price_cents, allow_nil: true, with_currency: :eur
  monetize :genset_lcoe_cents, allow_nil: true, with_currency: :eur
  monetize :grid_lcoe_cents, allow_nil: true, with_currency: :eur

  def select_at_least_one_current_type
    unless current_ac? or current_dc?
      errors.add(:current_dc, "or ac must be selected")
    end
  end

  def current_array
    list = []
    list << "AC" if current_ac?
    list << "DC" if current_dc?
    list
  end

  def currents
    if current_ac? and current_dc?
      "AC / DC"
    elsif current_ac?
      "AC"
    elsif current_dc?
      "DC"
    else
      "n/a"
    end
  end

  def voltage_range
    if voltage_min
      voltage_max ? "#{voltage_min} V - #{voltage_max} V" : "#{voltage_min} V"
    elsif voltage_max
      "#{voltage_max} V"
    else
      "n/a"
    end
  end

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
  end

  def appliance_quantity
    project_appliances.sum(:quantity)
  end

  def day_time_hour
    day_time.min.zero? ? day_time.hour : day_time.hour + 1
  end

  def night_time_hour
    night_time.min.zero? ? night_time.hour : night_time.hour + 1
  end

  def apparent_power
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.apparent_power
        sum += project_appliance.appliance.apparent_power * project_appliance.quantity
      end
    end
    sum
  end


  def peak_power
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.peak_power
        sum += project_appliance.appliance.peak_power * project_appliance.quantity
      end
    end
    sum
  end

  def daily_consumption
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.daily_consumption
        sum += project_appliance.daily_consumption * project_appliance.quantity
      end
    end
    sum
  end

  def yearly_consumption
    (daily_consumption * 365).to_f / 1000 if daily_consumption
  end

  def daytime_consumption
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.daytime_consumption
        sum += project_appliance.daytime_consumption * project_appliance.quantity
      end
    end
    sum
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      sum = 0
      project_appliances.each do |project_appliance|
        if project_appliance.appliance.apparent_power
          sum += project_appliance.method("hourly_consumption_#{hour}").call * project_appliance.quantity
        end
      end
      sum
    end
  end

  (0..23).each do |hour|
    define_method("hourly_rate_#{hour}") do
      apparent_power.zero? ? 0 : (method("hourly_consumption_#{hour}").call.to_f / apparent_power * 10)
    end
  end

  def all_consumptions?
    result = true
    appliances.each do |appliance|
      if appliance.apparent_power.blank?
        result = false
        break
      end
    end
    result
  end

  def year_hourly_consumption_csv(year, time_format, unit, load_by_use)
    CSV.generate(headers: true) do |csv|
      # CSV headers
      headers = ["#{time_format.capitalize}"]
      self.uses.each { |use| headers << "#{use.name} (#{unit})" } if load_by_use
      headers << "Total load (#{unit})"
      csv << headers
      # 24h pattern
      pattern =[]
      coeff = (unit == "VA") ? 1 : 1000
      (0..23).each do |hour|
        line = [hour]
        self.uses.each { |use| line << use.method("hourly_consumption_#{hour}").call(self).to_f / coeff } if load_by_use
        line << method("hourly_consumption_#{hour}").call.to_f / coeff
        pattern << line
      end
      # CSV year extrapolation
      start_time = DateTime.parse("#{year}-01-01")
      end_time = start_time.end_of_year
      (start_time.mjd..end_time.mjd).each do |day|
        pattern.each do |line|
          time = start_time + (day - start_time.mjd).day + line[0].hour
          csv_line = line.dup
          csv_line[0] = (time_format == "hour") ? (time.to_i - start_time.to_i)/3600 : time.strftime("%F %R")
          csv << csv_line
        end
      end
      csv
    end
  end

  # Prices

  def wiring_price_min_cents
    if wiring? and project_appliances.present?
      WIRING[:price_min_per_appliance_eur] * appliance_quantity * 100
    end
  end

  def wiring_price_max_cents
    if wiring? and project_appliances.present?
      WIRING[:price_max_per_appliance_eur] * appliance_quantity * 100
    end
  end

  def price_min_cents
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.price_min_cents
        sum += project_appliance.appliance.price_min_cents * project_appliance.quantity
      end
    end
    sum += wiring_price_min_cents if wiring_price_min_cents
    sum
  end

  def price_max_cents
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.price_max_cents
        sum += project_appliance.appliance.price_max_cents * project_appliance.quantity
      end
    end
    sum += wiring_price_max_cents if wiring_price_max_cents
    sum
  end

  def all_prices?
    result = true
    appliances.each do |appliance|
      if appliance.price_min.blank?
        result = false
        break
      end
    end
    result
  end

  # LCOE Calculation

  def consumption_discounted
    if yearly_consumption
      energy_discounted(yearly_consumption)
    end
  end

  def genset_price_cents
    if peak_power
      (peak_power / 1000) * GENSET[:price_per_kva_eur] * 100
    end
  end

  def genset_totex_discounted_cents
    if genset_price_cents and yearly_consumption and diesel_price_cents
      capex = genset_price_cents
      totex_discounted = capex_discounted(capex, GENSET[:lifetime])
      opex_o_and_m = capex * GENSET[:o_and_m_cost_ratio]
      opex_fuel = (yearly_consumption * diesel_price_cents).to_f / (GENSET[:lhv] * GENSET[:efficiency])
      totex_discounted += opex_discounted(opex_o_and_m + opex_fuel)
      totex_discounted
    end
  end

  def genset_lcoe_cents
    unless genset_totex_discounted_cents.blank? or consumption_discounted.blank? or consumption_discounted.zero?
      genset_totex_discounted_cents / consumption_discounted
    end
  end

  def grid_connection_charge_discounted_cents
    if grid_connection_charge_eur_cents and peak_power
      initial_cost = (peak_power / 1000) * grid_connection_charge_eur_cents
      capex_discounted(initial_cost, Float::INFINITY)
    end
  end

  def grid_subscription_charge_discounted_cents
    if grid_subscription_charge_eur_cents and peak_power
      yearly_cost = (peak_power / 1000) * grid_subscription_charge_eur_cents * 12
      opex_discounted(yearly_cost)
    end
  end

  def grid_consumption_charge_discounted_cents
    if grid_consumption_charge_eur_cents and yearly_consumption
      yearly_cost = yearly_consumption * grid_consumption_charge_eur_cents
      opex_discounted(yearly_cost)
    end
  end

  def grid_lcoe_cents
    unless consumption_discounted.blank? or consumption_discounted.zero?
      charges_discounted = 0
      charges_discounted += grid_connection_charge_discounted_cents if grid_connection_charge_discounted_cents
      charges_discounted += grid_subscription_charge_discounted_cents if grid_subscription_charge_discounted_cents
      charges_discounted += grid_consumption_charge_discounted_cents if grid_consumption_charge_discounted_cents
      charges_discounted == 0 ? nil : charges_discounted / consumption_discounted
    end
  end

  private

  def generate_unique_token
    self.token ||= SecureRandom.hex
  end

  def set_prices_in_eur
    if currency and Money.default_bank.get_rate(currency, :EUR)
      self.grid_connection_charge_eur_cents = grid_connection_charge.exchange_to(:EUR).fractional if grid_connection_charge
      self.grid_subscription_charge_eur_cents = grid_subscription_charge.exchange_to(:EUR).fractional if grid_subscription_charge
      self.grid_consumption_charge_eur_cents = grid_consumption_charge.exchange_to(:EUR).fractional if grid_consumption_charge
      self.diesel_price_eur_cents = diesel_price.exchange_to(:EUR).fractional if diesel_price
    end
  end
end
