class Blogpost < ApplicationRecord
  include ActiveStoragePath

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  has_rich_text :body
  has_one_attached_with :main_picture, path: -> { "Blog_pictures" }

  validates :title, :body, presence: true
end
