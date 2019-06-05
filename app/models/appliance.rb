class Appliance < ApplicationRecord
  belongs_to :user
  belongs_to :use

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :voltage, presence: true
  validates :power, presence: true
  validates :power_factor, presence: true
  validates :starting_coefficient, presence: true
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
