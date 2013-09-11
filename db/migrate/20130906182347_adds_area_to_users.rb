class AddsAreaToUsers < ActiveRecord::Migration
  def change
    add_column  :users, :work_area, :string
  end
end
