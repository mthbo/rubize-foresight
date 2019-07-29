class AppliancePolicy < ApplicationPolicy

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    record.projects.blank?
  end

end
