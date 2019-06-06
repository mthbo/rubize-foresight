class ApplianceVoltage < ApplicationRecord
  belongs_to :voltage
  belongs_to :appliance
end
