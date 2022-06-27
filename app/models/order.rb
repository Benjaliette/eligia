class Order < ApplicationRecord
  belongs_to :user
  has_many :order_accounts
  has_many :order_documents

  validates :deceased_first_name, :deceased_last_name,
            presence: true,
            format: { with: /\A\D+\z/, message: "ne doit contenir que des lettres" }
end
