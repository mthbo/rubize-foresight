class CommunicationModulePolicy < ApplicationPolicy

  def create?
    CommunicationModule.all.blank?
  end

  def update?
    true
  end

end
