class UserPolicy < ApplicationPolicy

  def update?
    user.admin? and record != user
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'Access to this page is restricted to admin users.'
      end
      # For a multi-tenant SaaS app, you may want to use:
      # scope.where(user: user)
    end
  end

end
