class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50, minimum: 6 }
  validates(:email,
            presence: true,
            length: { maximum: 255, minimum: 6 },
            format: { with: VALID_EMAIL_REGEX })
end
