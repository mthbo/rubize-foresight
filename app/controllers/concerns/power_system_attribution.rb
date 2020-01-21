module PowerSystemAttribution
  extend ActiveSupport::Concern

  def attribute_power_system_to_solar_system
    if current_user and @project.present? and @solar_system.present?
      select_power_system = current_user.power_systems.where(ac_out: @project.current_ac).where(system_voltage: @solar_system.system_voltage).where(power_in_min: -Float::INFINITY..@solar_system.power).where(power_in_max: @solar_system.power..Float::INFINITY).where(power_out_max: @project.apparent_power..Float::INFINITY).order(:power_out_max).first
      @solar_system.power_system = (select_power_system.present? ? select_power_system : nil)
      @solar_system.save
    end
  end

end
