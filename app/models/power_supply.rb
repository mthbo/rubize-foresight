class PowerSupply < ApplicationRecord
  belongs_to :project
  belongs_to :solar_panel
  belongs_to :battery
  belongs_to :power_system
end
