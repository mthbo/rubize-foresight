class SolarPanelPolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user && record.solar_systems.blank?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

end
