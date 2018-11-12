class CreateIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :v1_incomes do |t|
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
