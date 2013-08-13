class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  # validates(:email, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false})
  validates(:password, length: { minimum: 6})
  has_secure_password
end
