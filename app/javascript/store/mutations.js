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
  }
}