class Appliance < ApplicationRecord
  belongs_to :use
  has_many :sources, dependent: :destroy
  has_many :project_appliances
  has_many :projects, -> { distinct }, through: :project_appliances

  scope :ordered, -> { order(updated_at: :desc) }

  include PgSearch
  pg_search_scope :search,
    against: [ :name ],
    associated_against: {
      use: [ :name ]
    },
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: true
      }
    },
    order_within_rank: "updated_at DESC"

  mount_uploader :photo, PhotoUploader

  before_save :set_power_factor_and_starting_coeff

  DAY_TIME = 6
  NIGHT_TIME = 18
  TYPES = ["AC", "DC"]
  RATES = {
    "1" => "10",
    "0.9" => "9",
    "0.8" => "8",
    "0.7" => "7",
    "0.6" => "6",
    "0.5" => "5",
    "0.4" => "4",
    "0.3" => "3",
    "0.2" => "2",
    "0.1" => "1"
  }
  GRADES = ["A+++", "A++", "A+", "A", "B", "C", "D", "E", "F", "G"]
  GRADE_CLASSES = {
    "A+++" => "grade-a-plus-plus-plus",
    "A++" => "grade-a-plus-plus",
    "A+" => "grade-a-plus",
    "A" => "grade-a",
    "B" => "grade-b",
    "C" => "grade-c",
    "D" => "grade-d",
    "E" => "grade-e",
    "F" => "grade-f",
    "G" => "grade-g"
  }

  validates :name, presence: true
  validates :power, numericality: {greater_than_or_equal_to: 0, allow_nil: true}
  validates :power_factor, numericality: {greater_than: 0, less_than_or_equal_to: 1, allow_nil: true}
  validates :starting_coefficient, numericality: {greater_than_or_equal_to: 1, allow_nil: true}
  validates :current_type, inclusion: {in: TYPES, allow_blank: true}, presence: true
  validates :voltage_min, numericality: {greater_than: 0, allow_nil: true}
  validates :voltage_max, numericality: {greater_than: 0, allow_nil: true}
  validates :energy_grade, inclusion: {in: GRADES, allow_blank: true}

  monetize :price_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_max_cents, allow_nil: true, with_currency: :eur

  def apparent_power
    if power and power_factor
      (power / power_factor)
    end
  end

  def peak_power
    if apparent_power and starting_coefficient
      apparent_power * starting_coefficient
    end
  end

  def daily_consumption
    if apparent_power
      (0..23).reduce(0) { |sum, hour| sum + method("hourly_rate_#{hour}").call.to_f / 10 } * apparent_power
    end
  end

  def daytime_consumption
    if apparent_power
      (DAY_TIME...NIGHT_TIME).reduce(0) { |sum, hour| sum + method("hourly_rate_#{hour}").call.to_f / 10 } * apparent_power
    end
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption if apparent_power
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      if apparent_power
        (method("hourly_rate_#{hour}").call.to_f / 10 * apparent_power)
      end
    end
  end

  def frequencies
    if frequency_fifty_hz and current_type == "AC"
      frequency_sixty_hz ? "50 Hz or 60 Hz" : "50 Hz"
    elsif frequency_sixty_hz and current_type == "AC"
      "60 Hz"
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

  def price_max_cents
    sources.maximum(:price_eur_cents)
  end

  def price_min_cents
    sources.minimum("price_eur_cents - price_eur_cents * discount_rate / 100")
  end

  private

  def set_power_factor_and_starting_coeff
    self.power_factor = 1 if power_factor.blank?
    self.starting_coefficient = 1 if starting_coefficient.blank?
  end

end
