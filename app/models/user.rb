class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  after_create :send_welcome_email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_many :notifications, through: :orders

  validates :first_name, :last_name,
            presence: true,
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "Ne doit contenir que des lettres" }

  validates :phone_number, format: { with: /(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8}|([0-9\- ]){12})/, message: "Numéro incorrect" }

  def add_address!(address)
    cleaned_address = "#{address.line1}#{' ' unless address.line2}#{address.line2 unless address.line2}, #{address.postal_code} #{address.city}, #{address.country}"
    self.update(
      address: cleaned_address
    )
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end

  def slug_candidates
    [
      :last_name,
      %i[first_name last_name]
    ]
  end
end
