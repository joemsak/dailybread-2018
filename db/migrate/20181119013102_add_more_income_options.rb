class AddMoreIncomeOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :v1_incomes, :specific_monthly, :string
    add_column :v1_incomes, :specific_weekly, :string
  end
end
