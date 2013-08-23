class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
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

      t.timestamps
    end
    add_index :collections, :internal_invoice_number
  end
end
