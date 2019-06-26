class Appliance < ApplicationRecord
  belongs_to :use
  has_many :sources, dependent: :destroy
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
    }

  mount_uploader :photo, PhotoUploader

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

  validates :name, presence: true, uniqueness: true
  validates :power, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :power_factor, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}, allow_nil: true
  validates :starting_coefficient, numericality: {greater_than_or_equal_to: 1}, allow_nil: true
  validates :current_type, inclusion: {in: TYPES, allow_blank: true}
  validates :voltage_min, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :voltage_max, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :energy_grade, inclusion: {in: GRADES, allow_blank: true}

  monetize :min_price_cents, allow_nil: true, with_currency: :eur
  monetize :max_price_cents, allow_nil: true, with_currency: :eur

  def apparent_power
    (power / power_factor).round(1) if power and power_factor
  end

  def max_power
    (apparent_power * starting_coefficient).round(1) if apparent_power and starting_coefficient
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      (method("hourly_rate_#{hour}").call.to_f / 10 * apparent_power).round if apparent_power
    end
  end

  def daytime_consumption
    (DAY_TIME...NIGHT_TIME).reduce(0) { |result, hour| result + method("hourly_consumption_#{hour}").call } if apparent_power
  end

  def daily_consumption
    (0..23).reduce(0) { |result, hour| result + method("hourly_consumption_#{hour}").call } if apparent_power
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption if apparent_power
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

  def min_price_cents
    sources.all.map { |source| source.price_discount_eur_cents }.min
  end

  def max_price_cents
    sources.all.map { |source| source.price_eur_cents }.max
  end

end
