import Api from 'utils/api'

export default {
  initIncome ({ commit }) {
    Api.get("/income")
      .then(({ data }) => {
        if (data) {
          const { id, attributes } = data
          commit('incomePerPeriod', { id: id, amount: attributes.amount })
        } else {
          commit('incomePerPeriod', { id: null, amount: 0 })
        }
      })
  },

  updateIncome ({ commit }, payload) {
    Api.patch("/income", payload)
      .then(() => commit('incomePerPeriod', payload))
  }
}