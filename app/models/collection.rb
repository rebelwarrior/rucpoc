#coding: utf-8
class Collection < ActiveRecord::Base
  belongs_to :debtor, touch: true
  VALID_INT_NUM_REGEX = /\A[[[:digit:]]-]\z/i
  validates :internal_invoice_number, presence: true, format: { with: VALID_INT_NUM_REGEX, 
            message: "Debe ser un numero." }, uniqueness: true 
  validates :transaction_contact_person, length: {maximum: 144}
  
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