class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :body

  validates :name, :body, presence: { message: "Ne pas laisser vide" }
  validates :email,
    presence: { message: "Ne pas laisser vide" },
    format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "doit être une adresse mail compatible", message: "Adresse email invalide" }
end
