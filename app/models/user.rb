class User < ApplicationRecord
  after_create :send_welcome_email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy

  validates :first_name, :last_name,
            presence: true,
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "ne doit contenir que des lettres" }

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
