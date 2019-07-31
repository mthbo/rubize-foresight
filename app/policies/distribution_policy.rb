class DistributionPolicy < ApplicationPolicy

  def create?
    Distribution.all.blank?
  end

  def update?
    true
  end

end
