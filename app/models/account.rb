class Account < ApplicationRecord
  has_many :account_documents, dependent: :destroy
  has_many :documents, through: :account_documents
  has_many :order_accounts, dependent: :destroy
  belongs_to :category

  validates :name, presence: true
end
