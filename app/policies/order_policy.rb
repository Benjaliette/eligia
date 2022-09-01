class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    record.user == user
  end

  def create?
    true
  end

  def update?
    record.paid == false
  end

  def update_documents?
    record.paid == false
  end

  def change?
    record.paid == false
  end

  def recap?
    record.paid == false
  end

  def paiement?
    record.paid == false
  end

  def success?
    true
  end
end
