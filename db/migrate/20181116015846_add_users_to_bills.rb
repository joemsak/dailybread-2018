class AddUsersToBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :v1_bills, :user, index: true
    add_foreign_key :v1_bills, :v1_users, column: :user_id
  end
end
