class AddPrecisionToCollections < ActiveRecord::Migration
  def change
    change_table :collections do |t|
      t.change    :amount_owed, :decimal, precision: 12, scale: 2      
    end
  end
end
