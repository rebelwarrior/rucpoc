class CreateDebtors < ActiveRecord::Migration
  def change
    create_table :debtors do |t|
      t.string :name
      t.string :email
      t.string :tel
      t.string :address
      t.string :location
      t.string :contact_person
      t.string :employer_id_number

      t.timestamps
    end
  end
end
