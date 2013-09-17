class RenameBeingProcessedQmInCollections < ActiveRecord::Migration
  def change
    change_table :collections do |t|
      t.rename :being_processed?, :being_processed
    end
  end
end
