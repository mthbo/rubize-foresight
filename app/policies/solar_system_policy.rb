class SolarSystemPolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    record.project.user == user
  end

  def update?
    record.project.user == user
  end

  def destroy?
    record.project.user == user
  end

end
