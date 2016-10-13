class User < ApplicationRecord
    # before_save { self.email = email.downcase }
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50, minimum: 5 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,
              presence: true,
              length: { maximum: 255, minimum: 7 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 8 }
end
