class ImproveIncomes < ActiveRecord::Migration[5.2]
  def up
    add_column :v1_incomes, :payroll_type, :integer
    V1::Income.update_all(payroll_type: 2)
    change_column_null :v1_incomes, :payroll_type, false
  end

  def down
    remove_column :v1_incomes, :payroll_type
  end
end
