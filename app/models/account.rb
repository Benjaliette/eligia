class Account < ApplicationRecord
  has_many :account_documents, dependent: :destroy
  has_many :documents, through: :account_documents, dependent: :destroy
  has_many :order_accounts, dependent: :destroy
  belongs_to :subcategory

  validates :name, presence: true #, uniqueness: { scope: :subcategory }

  def self.validated_accounts_from_subcategory(subcategory)
    return where(status: 'validated', subcategory: subcategory)
  end
end
