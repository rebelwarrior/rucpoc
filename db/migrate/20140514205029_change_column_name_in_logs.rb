class ChangeColumnNameInLogs < ActiveRecord::Migration
  def change
    rename_column :logs, :collection_id, :debt_id
  end
end
