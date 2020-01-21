class SolarSystemPolicy < ApplicationPolicy

  def create?
    true
  end

  def update?
    record.project.user == user
  end

  def destroy?
    record.project.user == user
  end

end
