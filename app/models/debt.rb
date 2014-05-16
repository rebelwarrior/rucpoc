class Debt < ActiveRecord::Base
  belongs_to :debtor, touch: true
  has_many :logs #depended destroy?
  VALID_INT_NUM_REGEX = /\A([[:digit:]]|[A-Z]|-)*\z/i  #Must remove alphanum from this if not neded
  VALID_NUM_REGEX = /\A\d*/
  validates :internal_invoice_number, presence: true, format: { with: VALID_INT_NUM_REGEX, 
            message: "Debe ser un número." }, uniqueness: true 
  validates :transaction_contact_person, length: {maximum: 144}
  validates :debtor_id, presence: true
  validates :amount_owed, format: { with: VALID_NUM_REGEX, 
            message: "Debe ser un número."}
  validates :bounced_check_number, format: { with: VALID_INT_NUM_REGEX, 
            message: "Debe ser un número."}
  
  def find_debtor_name(debtor_id)
    debtor = Debtor.find_by_id(debtor_id)
    debtor.nil? ? 'NULL' : debtor.name
  end
   
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names + [:debtor_name]
      all.each do |collection|
        debtor_name = collection.find_debtor_name(collection.attributes["debtor_id"])
        # csv << collection.attributes.values_at(*column_names)
        csv << (collection.attributes.values_at(*column_names) << debtor_name)
      end
    end
  end

  private
    def self.to_plain_csv(options = {}) #For portability of code only.
      CSV.generate(options) do |csv|
        csv << column_names
        all.each do |collection|
          csv << collection.attributes.values_at(*column_names)
        end
      end
    end
  
end


__END__
t.string    :internal_invoice_number
t.decimal   :amount_owed
t.boolean   :paid?, default: false
t.integer   :collection_payment_id_number
t.string    :collection_payment_emmiter_info
t.string    :transaction_contact_person
t.string    :notes
t.string    :bounced_check_bank
t.string    :bounced_check_number
t.integer   :debtor_id
t.boolean   :being_processed?, default: false
  
  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     row_hash = row.to_hash
  #     #Analyze row_hash for correct contents.
  #     debtor = Debtor.find_by_id(row_hash[:debtor_id]) 
  #     collection.attributes = row_hash.slice(*accessible_attributes)
  #     # .save!
  #     Collection.create! collection.attributes
  #   end
  # end