class Debtor < ActiveRecord::Base
  #Deudor
   before_save { self.email = email.downcase }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   VALID_TEL_REGEX =/\A[0-9]{3}-?[0-9]{3}-?[0-9]{4}\z/
   VALID_EIN_REGEX =/\A(\z|[0-9]{2}-?[0-9]{7})\z/ 
   validates(:email, format: { with: VALID_EMAIL_REGEX})
   validates :name, presence: true
   validates :employer_id_number, uniqueness: true
   validates :tel, format: { with: VALID_TEL_REGEX }
   validates :employer_id_number, format: { with: VALID_EIN_REGEX }
  
end
