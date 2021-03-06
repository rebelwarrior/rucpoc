#coding: utf-8
class User < ActiveRecord::Base
  #Usuario
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  # validates(:email, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_JCA_EMAIL_REGEX = /\A[\w+\-.]+@jca\.pr\.gov/i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX,
            message: "El email debe ser valido."}, uniqueness: { case_sensitive: false})
  validates(:password, length: { minimum: 6})
  has_secure_password
  has_many :logs
  has_one :department
  has_one :role
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
  
end



