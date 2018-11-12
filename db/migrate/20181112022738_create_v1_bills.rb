class CreateV1Bills < ActiveRecord::Migration[5.2]
  def change
    create_table :v1_bills do |t|
      t.integer :amount, null: false
      t.string :name, null: false
      t.integer :pay_period, null: false

      t.timestamps
    end
  end
end
