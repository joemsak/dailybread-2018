class AddUsersToV1Incomes < ActiveRecord::Migration[5.2]
  def change
    add_reference :v1_incomes, :user, index: true
    add_foreign_key :v1_incomes, :v1_users, column: :user_id
  end
end
