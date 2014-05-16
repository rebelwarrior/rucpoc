#coding: utf-8
class Debtor < ActiveRecord::Base
  #Deudor
   has_many :collections  #, dependent: :destroy
   has_many :logs, through: :collections
   before_save { self.email = email.downcase }
   before_save { self.employer_id_number = 
     employer_id_number.match(VALID_EIN_REGEX).captures[-2..-1].join('-') unless employer_id_number.blank?}
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   VALID_TEL_REGEX = /\A(\z|([0-9]{3}-?[0-9]{3}-?[0-9]{4}))\z/
   VALID_EIN_REGEX = /\A(\z|([0-9]{2})-?([0-9]{7}))\z/ 
   VALID_EIN_OR_SS_REGEX = /\A(\z|([[:digit:]]{3}|[[:digit:]]{2})-?[[:digit:]]{2}-?[[:digit:]]{4})\z/
   validates(:email, format: { with: VALID_EMAIL_REGEX})
   validates :name, presence: true
   validates :employer_id_number, uniqueness: true, 
     unless: Proc.new { |deb| deb.employer_id_number.blank?  }
   validates :tel, format: { with: VALID_TEL_REGEX, 
     message: "Debe de der un número de teléfono válido: 'xxx-xxx-xxx'" }
   validates :employer_id_number, format: { with: VALID_EIN_REGEX,
     message: "El Número de Seguro Social Patronal debe de ser válido: 'xx-xxxxxxx' o en blanco." }

  
  def self.search(search_term)  
    if search_term =~ /\A[0-9]{9}\z/
      #Consider using this regex below as both regex
      ein_regex = /\A([0-9]{2})-?([0-9]{7})\z/
      search_term = search_term.match(ein_regex).captures.join('-')
      result = where('employer_id_number LIKE ?', "%#{search_term}%")
    elsif search_term
      search_term = search_term.downcase if (search_term.class == String)
      result = where('LOWER(name) LIKE ? OR employer_id_number LIKE ? OR email LIKE ?', 
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
  
  # def self.search_ein(search_term) #For API
  #   if search_term
  #     # Must bench mark below code for easier EIN lookup.
  #     ein_regex = /\A([0-9]{2})([0-9]{7})\z/ 
  #     if search_term =~ ein_regex
  #       search_term = search_term.match(ein_regex).captures.join('-') 
  #     end
  #     search_term = search_term.downcase
  #     result = where('employer_id_number LIKE ?', "%#{search_term}%")
  #   else
  #     'null'
  #   end
  # end
  
  
end

__END__
t.string   "name"
t.string   "email"
t.string   "tel"
#TODO add t.string "ext"
t.string   "address"
t.string   "location"
t.string   "contact_person"
t.string   "employer_id_number"
t.datetime "created_at"
t.datetime "updated_at"
