class User < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  after_create :send_welcome_email

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy

  validates :first_name, :last_name,
            presence: true,
            format: { with: /\A([a-zàâçéèêëîïôûùüÿñæœ'.-]|\s)*\z/i, message: "ne doit contenir que des lettres" }

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
