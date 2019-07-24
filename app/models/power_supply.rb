class PowerSupply < ApplicationRecord
  belongs_to :project_id
  belongs_to :solar_panel_id
  belongs_to :battery_id
  belongs_to :power_system_id
end
