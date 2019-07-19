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
    true
  end

  def refresh_load?
    true
  end

end
