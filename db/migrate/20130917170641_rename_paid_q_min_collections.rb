class RenamePaidQMinCollections < ActiveRecord::Migration
  def change
    change_table :collections do |t|
      t.rename :paid?, :paid
    end
  end
end
