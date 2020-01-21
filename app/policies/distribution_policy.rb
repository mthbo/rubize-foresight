class DistributionPolicy < ApplicationPolicy

  def create?
    user.distributions.blank?
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
