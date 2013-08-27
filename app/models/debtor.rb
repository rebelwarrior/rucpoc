#coding: utf-8
class Debtor < ActiveRecord::Base
  #Deudor
   has_many :collections  #, dependent: :destroy
   before_save { self.email = email.downcase }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   VALID_TEL_REGEX =/\A[0-9]{3}-?[0-9]{3}-?[0-9]{4}\z/
   VALID_EIN_REGEX =/\A(\z|[0-9]{2}-?[0-9]{7})\z/ 
   validates(:email, format: { with: VALID_EMAIL_REGEX})
   validates :name, presence: true
   validates :employer_id_number, uniqueness: true
   validates :tel, format: { with: VALID_TEL_REGEX }
   validates :employer_id_number, format: { with: VALID_EIN_REGEX }
  
  def self.search(search_term)
    if search_term
      find(:all, :conditions => ['name LIKE ?', "%#{search_term}%"])
    else
      find(:all)
    end
  end
  
  
end
