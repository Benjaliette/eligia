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
    record.user == user
  end

  def created?
    record.paid == false
  end

  def new?
    record.paid == false
  end

  def update?
    record.paid == false
  end

  def update_documents?
    record.paid == false
  end

  def recap?
    record.paid == false
  end

  def paiement?
    record.paid == false || Rails.env == "development" || Rails.env == "staging"
  end

  def success?
    record.notifications.count == 0
  end

  def destroy?
    true
  end

  def webhook?
    skip_authorization
  end

  def show_invoice_pdf?
    record.user == user
  end
end
