class Use < ApplicationRecord
  belongs_to :user
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

  validates :name, presence: true, uniqueness: {scope: :user}

  monetize :price_min_cents, allow_nil: true, with_currency: :eur
  monetize :price_max_cents, allow_nil: true, with_currency: :eur

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
    sum
  end

  def peak_power(project)
    sum = 0
    project_appliances(project).each do |project_appliance|
      if project_appliance.appliance.peak_power
        sum += project_appliance.appliance.peak_power * project_appliance.quantity
      end
    end
    sum
  end

  def daily_consumption(project)
    sum = 0
    project_appliances(project).each do |project_appliance|
      if project_appliance.daily_consumption
        sum += project_appliance.daily_consumption * project_appliance.quantity
      end
    end
    sum
  end

  def daytime_consumption(project)
    sum = 0
    project_appliances(project).each do |project_appliance|
      if project_appliance.daytime_consumption
        sum += project_appliance.daytime_consumption * project_appliance.quantity
      end
    end
    sum
  end

  def nighttime_consumption(project)
    daily_consumption(project) - daytime_consumption(project)
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

  def price_min_cents(project=nil)
    if project.present?
      sum = 0
      project_appliances(project).each do |project_appliance|
        if project_appliance.appliance.price_min_cents
          sum += project_appliance.appliance.price_min_cents * project_appliance.quantity
        end
      end
      sum
    end
  end

  def price_max_cents(project=nil)
    if project.present?
      sum = 0
      project_appliances(project).each do |project_appliance|
        if project_appliance.appliance.price_max_cents
          sum += project_appliance.appliance.price_max_cents * project_appliance.quantity
        end
      end
      sum
    end
  end

end
