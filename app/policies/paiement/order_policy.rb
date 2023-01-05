class Paiement::OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    record.notifications.count == 0 && record.paid
  end

  def update?
    record.paid == false
  end
end
