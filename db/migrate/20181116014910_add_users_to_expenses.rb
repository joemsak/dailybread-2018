class AddUsersToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_reference :v1_expenses, :user, index: true
    add_foreign_key :v1_expenses, :v1_users, column: :user_id
  end
end
