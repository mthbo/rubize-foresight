class ProjectPolicy < ApplicationPolicy

  def show?
    true
  end

  def create?
    true
  end

  def duplicate?
    create?
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def public?
    true
  end

end
