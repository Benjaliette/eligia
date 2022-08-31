class UserPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    true
  end

  def control_password?
    true
  end

  def control_password_check?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end
end
