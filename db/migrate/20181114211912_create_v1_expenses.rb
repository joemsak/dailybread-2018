class CreateV1Expenses < ActiveRecord::Migration[5.2]
  def change
    create_table :v1_expenses do |t|
      t.string :category, null: false
      t.string :name
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :made_on, null: false

      t.timestamps
    end
  end
end
