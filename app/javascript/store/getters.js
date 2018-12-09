const calculateSum = (items) => {
  return items.reduce((sum, i) => sum + i.amount, 0)
}

export default {
  totalAfterBillsAndExpenses: (state) => {
    let billSum

    if (state.currentPayPeriod == 1) {
      billSum = calculateSum(state.firstPeriodBills)
    } else {
      billSum = calculateSum(state.secondPeriodBills)
    }

    const expenseSum = calculateSum(state.expenses)
    return state.incomePerPeriod.amount - billSum - expenseSum
  }
}