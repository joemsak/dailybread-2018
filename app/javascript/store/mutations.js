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
    if (data.payPeriod == 1 || data.pay_period == 1) {
      state.firstPeriodBills.push(data)
    } else {
      state.secondPeriodBills.push(data)
    }
  }
}