import Api from 'utils/api'

export default {
  initApp ({ commit }) {
    const payPeriod = window.location.search.match(/payPeriod=(\d)/)[1]

    if (payPeriod) {
      commit('currentPayPeriod', parseInt(payPeriod))
    } else {
      Api.get("/current_pay_period")
        .then(({ data }) => commit('currentPayPeriod', data.attributes.current))
    }

    Api.get("/income")
      .then(({ data }) => {
        if (data) {
          const { id, attributes } = data
          commit('incomePerPeriod', { id: id, amount: attributes.amount })
        } else {
          commit('incomePerPeriod', { id: null, amount: 0 })
        }
      })

    Api.get(`/bills`)
      .then(({ data }) => {
        for (const { id, attributes } of data) {
          commit('bills', { id, ...attributes })
        }
      })
  },

  updateIncome ({ commit }, payload) {
    Api.patch("/income", payload)
      .then(() => commit('incomePerPeriod', payload))
  },

  createBill ({ commit }, payload) {
    Api.post('/bills', payload)
      .then(({ data: { id, attributes } }) => commit('bills', { id, ...attributes }))
  }
}