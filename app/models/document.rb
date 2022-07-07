class Document < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :format, presence: true
end
