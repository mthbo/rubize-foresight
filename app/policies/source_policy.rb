class SourcePolicy < ApplicationPolicy

  def create?
    true
  end

  def update?
    record.appliance.user == user
  end

  def destroy?
    record.appliance.user == user
  end

end
