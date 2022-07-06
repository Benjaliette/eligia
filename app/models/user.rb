class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy

  validates :first_name, :last_name,
            presence: true,
            format: { with: /\A[a-zA-Z]+\z/, message: "ne doit contenir que des lettres" }
end
