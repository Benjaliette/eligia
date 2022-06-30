class Order < ApplicationRecord
  monetize :amount_cents

  belongs_to :user
  has_many :order_accounts
  has_many :order_documents
  belongs_to :pack

  validates :deceased_first_name, :deceased_last_name,
            presence: true,
            format: { with: /\A\D+\z/, message: "ne doit contenir que des lettres" }

  accepts_nested_attributes_for :order_accounts, allow_destroy: true
end
