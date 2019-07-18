class Project < ApplicationRecord
  has_many :project_appliances, dependent: :destroy
  has_many :appliances, -> { distinct }, through: :project_appliances
  has_many :uses, -> { distinct }, through: :appliances

  scope :ordered, -> { order(updated_at: :desc) }

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

  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true, inclusion: {in: ISO3166::Country.codes }
  validates :city, presence: true
  validates :day_time, presence: true
  validates :night_time, presence: true
  validates :voltage_min, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :voltage_max, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :frequency, inclusion: {in: FREQUENCIES, allow_blank: true}
  validate :select_at_least_one_current_type

  def select_at_least_one_current_type
    unless current_ac? or current_dc?
      errors.add(:current_dc, "or ac must be selected")
    end
  end

  def currents
    currents = []
    currents << "AC" if current_ac?
    currents << "DC" if current_dc?
  end

  def country_name
    if country_code
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end
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
      sum += project_appliance.appliance.apparent_power if project_appliance.appliance.apparent_power
    end
    sum.round(1)
  end

  def peak_power
    sum = 0
    project_appliances.each do |project_appliance|
      sum += project_appliance.appliance.peak_power if project_appliance.appliance.peak_power
    end
    sum.round(1)
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      sum = 0
      project_appliances.each do |project_appliance|
        sum += project_appliance.method("hourly_consumption_#{hour}").call if project_appliance.appliance.apparent_power
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
    day_h = day_time.hour
    day_m = day_time.min
    night_h = night_time.hour
    night_m = night_time.min
    consumption = (day_h...night_h).reduce(0) { |sum, hour| sum + method("hourly_consumption_#{hour}").call }
    consumption -= day_m.to_f / 60 * method("hourly_consumption_#{day_h}").call
    consumption += night_m.to_f / 60 * method("hourly_consumption_#{night_h}").call
    consumption.round
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption
  end
end
