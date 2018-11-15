class CreateV1Users < ActiveRecord::Migration[5.2]
  def change
    create_table :v1_users do |t|
      t.string :email, null: false
      t.integer :status, null: false, default: 0

      t.string :magic_signin_token, null: false
      t.datetime :magic_signin_token_expires_at

      t.string :email_confirmation_token, null: false
      t.datetime :email_confirmation_token_expires_at, null: false

      t.timestamps
    end
  end
end
