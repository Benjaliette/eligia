class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.admin?
        # scope.all
        scope.where(user: user)
      else
        scope.where(user: user)
      end
    end
  end

  def show?
    record.paid == false
  end

  def create?
    record.paid == false
  end

  def new?
    record.paid == false
  end

  def update?
    record.paid == false
  end

  def destroy?
    true
  end

  def show_invoice_pdf?
    record.user == user
  end
end
