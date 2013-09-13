class AddDeptartmentAndRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer, default: 0
    add_column :users, :department_id, :integer, default: 0
  end
end
