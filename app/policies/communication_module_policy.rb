class CommunicationModulePolicy < ApplicationPolicy

  def create?
    user.communication_modules.blank?
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
