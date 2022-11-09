class Blogpost < ApplicationRecord
  has_rich_text :body
  has_one_attached :main_picture

  validates :title, :body, presence: true
end
