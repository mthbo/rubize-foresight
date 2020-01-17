class ProjectAppliance < ApplicationRecord
  belongs_to :project
  belongs_to :appliance
  scope :ordered, -> { order(updated_at: :desc) }

  validates :quantity, numericality: {greater_than: 0}

  def daily_consumption
    if appliance.apparent_power
      (0..23).reduce(0) { |sum, hour| sum + method("hourly_rate_#{hour}").call.to_f / 10 } * appliance.apparent_power
    end
  end

  def daytime_consumption
    if appliance.apparent_power and project.day_time and project.night_time
      day_h = project.day_time.hour
      day_m = project.day_time.min
      night_h = project.night_time.hour
      night_m = project.night_time.min
      consumption = (day_h...night_h).reduce(0) { |sum, hour| sum + method("hourly_rate_#{hour}").call.to_f / 10 } * appliance.apparent_power
      consumption -= day_m.to_f / 60 * method("hourly_rate_#{day_h}").call.to_f / 10 * appliance.apparent_power
      consumption += night_m.to_f / 60 * method("hourly_rate_#{night_h}").call.to_f / 10 * appliance.apparent_power
    end
  end

  def nighttime_consumption
    daily_consumption - daytime_consumption if appliance.apparent_power
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do
      if appliance.apparent_power
        (method("hourly_rate_#{hour}").call.to_f / 10 * appliance.apparent_power)
      end
    end
  end
end
