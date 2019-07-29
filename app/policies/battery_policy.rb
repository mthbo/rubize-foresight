class BatteryPolicy < ApplicationPolicy

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    record.solar_systems.blank?
  end

end
