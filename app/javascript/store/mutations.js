import Vue from "vue";

export default {
  currentPayPeriod(state, period) {
    state.currentPayPeriod = period
  },

  incomePerPeriod(state, payload) {
    for (const key in payload) {
      Vue.set(state.incomePerPeriod, key, payload[key])
    }
  },

  bills(state, data) {
    const firstPeriodIdx = state.firstPeriodBills.findIndex(b => b.id === data.id)
    const secondPeriodIdx = state.secondPeriodBills.findIndex(b => b.id === data.id)

    if (data._delete && firstPeriodIdx >= 0) {
      return state.firstPeriodBills.splice(firstPeriodIdx, 1)
    } else if (data._delete) {
      return state.secondPeriodBills.splice(secondPeriodIdx, 1)
    }

    if (data.payPeriod == 1 && firstPeriodIdx >= 0) {
      state.firstPeriodBills.splice(firstPeriodIdx, 1, data)
    } else if (data.payPeriod == 2 && secondPeriodIdx >= 0) {
      state.secondPeriodBills.splice(secondPeriodIdx, 1, data)
    }

    if (data.payPeriod == 1 && secondPeriodIdx >= 0) {
      state.firstPeriodBills.unshift(data)
      state.secondPeriodBills.splice(secondPeriodIdx, 1)
    } else if (data.payPeriod == 2 && firstPeriodIdx >= 0) {
      state.secondPeriodBills.unshift(data)
      state.firstPeriodBills.splice(firstPeriodIdx, 1)
    }

    if (firstPeriodIdx < 0 && secondPeriodIdx < 0) {
      if (data.payPeriod == 1) {
        state.firstPeriodBills.unshift(data)
      } else {
        state.secondPeriodBills.unshift(data)
      }
    }
  },

  editingBill(state, value) {
    state.editingBill = value
  },

  expenses(state, data) {
    const expensesIdx = state.expenses.findIndex(e => e.id === data.id)

    if (data._delete) {
      return state.expenses.splice(expensesIdx, 1)
    }

    if (typeof(data.madeOn) === 'string') {
      const parts = data.madeOn.split("T")[0].split("-")
      const year = parts[0]
      const month = parts[1]
      const day = parts[2]

      data.madeOn = new Date([month, day, year].join("/"))
    } else {
      data.madeOn = data.madeOn.toLocaleDateString()
    }

    if (expensesIdx >= 0) {
      state.expenses.splice(expensesIdx, 1, data)
    } else {
      state.expenses.unshift(data)
    }
  },

  editingExpense(state, value) {
    state.editingExpense = value
  },
}