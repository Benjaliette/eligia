class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :body

  validates :name, :body, presence: true
  validates :email,
    presence: true,
    format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "doit être une adresse mail compatible" }
end
