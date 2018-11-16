class AddRefreshToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :v1_users, :access_refresh_token, :string
    V1::User.find_each(&:regenerate_access_refresh_token)
    change_column_null :v1_users, :access_refresh_token, false
  end

  def down
    remove_column :v1_users, :access_refresh_token
  end
end
