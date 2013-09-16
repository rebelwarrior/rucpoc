class AddDeletedtoLogs < ActiveRecord::Migration
  def change
    add_column :logs, :deleted?, :boolean, default: false
  end
end
