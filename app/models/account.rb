class Account < ApplicationRecord
  has_many :account_documents
  has_many :documents, through: :account_documents
  belongs_to :category
end
