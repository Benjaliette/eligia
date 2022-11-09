class Blogpost < ApplicationRecord
  include ActiveStoragePath

  has_rich_text :body
  has_one_attached_with :main_picture, path: -> { "Blog_pictures" }

  validates :title, :body, presence: true
end
