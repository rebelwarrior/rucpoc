#coding: utf-8
class Debtor < ActiveRecord::Base
  #Deudor
   has_many :collections  #, dependent: :destroy
   has_many :logs, through: :collections
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
      result = where('name LIKE ? OR employer_id_number LIKE ? OR email LIKE ?', 
                     "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
      #result = find(:all, :conditions => ['name LIKE ?', "%#{search_term}%"])
      # if result.size.zero?
      #   "No result found."
      #   order('created_at DESC') # default is all
      # else
      #   "Results for #{search_term}"
      #   result
      # end
    else
      # find(:all)
      all
    end
  end
  
  
end
