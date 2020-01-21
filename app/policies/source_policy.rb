class SourcePolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    record.appliance.user == user
  end

  def update?
    record.appliance.user == user
  end

  def destroy?
    record.appliance.user == user
  end

end
