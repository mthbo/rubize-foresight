class Voltage < ApplicationRecord
  validates :level, presence: true, uniqueness: true
  has_many :appliance_voltages, dependent: :destroy
  has_many :appliances, through: :appliance_voltages
end
