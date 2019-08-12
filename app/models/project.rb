class Project < ApplicationRecord
  has_many :project_appliances, dependent: :destroy
  has_many :appliances, -> { distinct }, through: :project_appliances
  has_many :uses, -> { distinct }, through: :appliances
  has_many :solar_systems, dependent: :destroy

  scope :ordered, -> { order(updated_at: :desc) }

  before_save :generate_unique_token

  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: true
      }
    }

  FREQUENCIES = ["50 Hz", "60 Hz"]

  validates :name, presence: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :day_time, presence: true
  validates :night_time, presence: true
  validates :voltage_min, numericality: {greater_than_or_equal_to: 0, allow_nil: true}
  validates :voltage_max, numericality: {greater_than: 0, allow_nil: true}
  validates :frequency, inclusion: {in: FREQUENCIES, allow_blank: true}
  validate :select_at_least_one_current_type

  monetize :price_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_max_cents, allow_nil: true, with_currency: :eur
  monetize :price_total_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_total_max_cents, allow_nil: true, with_currency: :eur

  def select_at_least_one_current_type
    unless current_ac? or current_dc?
      errors.add(:current_dc, "or ac must be selected")
    end
  end

  def generate_unique_token
    self.token ||= SecureRandom.hex
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
    sum.round(1)
  end

  def peak_power
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.peak_power
        sum += project_appliance.appliance.peak_power * project_appliance.quantity
      end
    end
    sum.round(1)
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
      apparent_power.zero? ? 0 : (method("hourly_consumption_#{hour}").call.to_f / apparent_power * 10).round(2)
    end
  end

  def daily_consumption
    (0..23).reduce(0) { |sum, hour| sum + method("hourly_consumption_#{hour}").call }
  end

  def daytime_consumption
    if day_time and night_time
      day_h = day_time.hour
      day_m = day_time.min
      night_h = night_time.hour
      night_m = night_time.min
      consumption = (day_h...night_h).reduce(0) { |sum, hour| sum + method("hourly_consumption_#{hour}").call }
      consumption -= day_m.to_f / 60 * method("hourly_consumption_#{day_h}").call
      consumption += night_m.to_f / 60 * method("hourly_consumption_#{night_h}").call
      consumption.round
    else
      0
    end
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption
  end

  def price_min_cents
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.price_min_cents
        sum += project_appliance.appliance.price_min_cents * project_appliance.quantity
      end
    end
    sum.round(1)
  end

  def price_max_cents
    sum = 0
    project_appliances.each do |project_appliance|
      if project_appliance.appliance.price_max_cents
        sum += project_appliance.appliance.price_max_cents * project_appliance.quantity
      end
    end
    sum.round(1)
  end

  def price_total_min_cents
    sum = price_min_cents
    sum += solar_systems.first.price_min_cents if (solar_systems.present? and solar_systems.first.price_min_cents)
    sum
  end

  def price_total_max_cents
    sum = price_max_cents
    sum += solar_systems.first.price_max_cents if (solar_systems.present? and solar_systems.first.price_max_cents)
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
end
