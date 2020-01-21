class CommunicationModulePolicy < ApplicationPolicy

  def new?
    user.communication_modules.persisted.blank?
  end

  def create?
    record.user == user && user.communication_modules.persisted.blank?
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
