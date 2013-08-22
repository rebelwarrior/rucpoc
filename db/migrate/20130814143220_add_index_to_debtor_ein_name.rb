class AddIndexToDebtorEinName < ActiveRecord::Migration
  def change
    add_index :debtors, :employer_id_number
    add_index :debtors, :name, unique: true
  end
end
