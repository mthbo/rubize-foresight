class Appliance < ApplicationRecord
  belongs_to :use
  has_many :appliance_voltages, dependent: :destroy
  has_many :voltages, through: :appliance_voltages

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :power_factor, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :starting_coefficient, numericality: {greater_than_or_equal_to: 1}
  validates :current_type, presence: true

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

  VOLTAGES = [5, 12, 24, 48, 120, 230, 400]

  def apparent_power
    (power / power_factor).round(1)
  end

  def max_power
    (apparent_power * starting_coefficient).round(1)
  end

  (0..23).each do |i|
    define_method("hourly_consumption_#{i}") do
      (method("hourly_rate_#{i}").call.to_f / 10 * apparent_power).round
    end
  end

  def daily_consumption
    result = 0
    (0..23).each { |i| result += method("hourly_consumption_#{i}").call }
    result
  end

end
