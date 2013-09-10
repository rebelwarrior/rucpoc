class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :content
      t.integer :collection_id
      t.integer :user_id

      t.timestamps
    end
    add_index :logs, :collection_id
    add_index :logs, [ :user_id, :created_at ]
  end
end
