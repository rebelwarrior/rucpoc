class ChangeTableNameCollectionsToDebts < ActiveRecord::Migration
  def change
    rename_table :collections, :debts
  end
end
