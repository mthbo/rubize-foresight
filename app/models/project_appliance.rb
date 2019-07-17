class ProjectAppliance < ApplicationRecord
  belongs_to :project
  belongs_to :appliance
  scope :ordered, -> { order(updated_at: :desc) }

  validates :quantity, numericality: {greater_than: 0}

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      if appliance.apparent_power
        (method("hourly_rate_#{hour}").call.to_f / 10 * appliance.apparent_power).round
      end
    end
  end

  def daily_consumption
    (0..23).reduce(0) { |result, hour| result + method("hourly_consumption_#{hour}").call } if appliance.apparent_power
  end

  def daytime_consumption
    if appliance.apparent_power
      day_hour = project.day_time.hour
      day_min = project.day_time.min
      night_hour = project.night_time.hour
      night_min = project.night_time.min
      consumption = (day_hour...night_hour).reduce(0) { |result, hour| result + method("hourly_consumption_#{hour}").call }
      consumption -= day_min.to_f / 60 * method("hourly_consumption_#{day_hour}").call
      consumption += night_min.to_f / 60 * method("hourly_consumption_#{night_hour}").call
      consumption.round
    end
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption if appliance.apparent_power
  end
end
