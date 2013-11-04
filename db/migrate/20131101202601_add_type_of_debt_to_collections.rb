class AddTypeOfDebtToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :type_of_debt, :string
    add_column :collections, :original_debt_date, :date
    add_column :collections, :original_debt, :integer, default: 0
    add_column :collections, :amount_paid, :integer, default: 0
  end
end
