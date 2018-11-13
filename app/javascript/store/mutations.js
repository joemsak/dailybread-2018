import Vue from "vue";

export default {
  incomePerPeriod(state, payload) {
    for (const key in payload) {
      Vue.set(state.incomePerPeriod, key, payload[key])
    }
  }
}