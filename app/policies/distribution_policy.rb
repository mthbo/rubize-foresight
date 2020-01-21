class DistributionPolicy < ApplicationPolicy

  def new?
    user.distributions.persisted.blank?
  end

  def create?
    record.user == user && user.distributions.persisted.blank?
  end

  def update?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

end
