class Use < ApplicationRecord
  has_many :appliances, dependent: :nullify
  has_many :project_appliances, through: :appliances
  has_many :projects, -> { distinct }, through: :project_appliances
  scope :ordered, -> { order(name: :asc) }

  DAY_TIME = 6
  NIGHT_TIME = 18
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

  validates :name, presence: true, uniqueness: true

  def project_appliances(project)
    project.project_appliances.joins(:appliance).where(appliances: {use_id: self.id})
  end

  def apparent_power(project)
    sum = 0
    project_appliances(project).each do |project_appliance|
      if project_appliance.appliance.apparent_power
        sum += project_appliance.appliance.apparent_power * project_appliance.quantity
      end
    end
    sum.round(1)
  end

  def peak_power(project)
    sum = 0
    project_appliances(project).each do |project_appliance|
      if project_appliance.appliance.peak_power
        sum += project_appliance.appliance.peak_power * project_appliance.quantity
      end
    end
    sum.round(1)
  end

  (0..23).each do |hour|
    define_method("hourly_consumption_#{hour}") do |project|
      sum = 0
      project_appliances(project).each do |project_appliance|
        if project_appliance.appliance.apparent_power
          sum += project_appliance.method("hourly_consumption_#{hour}").call * project_appliance.quantity
        end
      end
      sum
    end
  end

  (0..23).each do |hour|
    define_method("hourly_rate_#{hour}") do |project|
      apparent_power(project).zero? ? 0 : (method("hourly_consumption_#{hour}").call(project).to_f / apparent_power(project) * 10).round(2)
    end
  end

  def daily_consumption(project)
    (0..23).reduce(0) { |sum, hour| sum + method("hourly_consumption_#{hour}").call(project) }
  end

end
