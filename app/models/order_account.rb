class OrderAccount < ApplicationRecord
  belongs_to :order
  belongs_to :account

  accepts_nested_attributes_for :account, allow_destroy: true, reject_if: :reject_accounts

  def reject_accounts(attributes)
    attributes['name'].blank?
  end
end
