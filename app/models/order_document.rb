class OrderDocument < ApplicationRecord
  has_one_attached :document_file

  belongs_to :document
  belongs_to :order
end
