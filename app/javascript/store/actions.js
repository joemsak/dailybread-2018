import Api from 'utils/api'

export default {
  initApp ({ dispatch }) {
    const search = window.location.search

    if (window.localStorage.getItem('jwt')) {
      dispatch('initEverything')
    } else if (search && search.match(/magicLinkToken=/)) {
      const token = search.match(/magicLinkToken=(\w+)/)[1]

      Api.post('/access_tokens', { token })
        .then(json => {
          window.localStorage.setItem('jwt', json.jwt)
          dispatch('initEverything')
        })
    } else if (search && search.match(/emailConfirmationToken=/)) {
      const token = search.match(/emailConfirmationToken=(\w+)/)[1]

      Api.post('/email_confirmations', { token })
        .then(json => {
          window.localStorage.setItem('jwt', json.jwt)
          dispatch('initEverything')
        })
    }
  },

  initEverything ({ dispatch }) {
    dispatch('initPayPeriod')
    dispatch('initIncome')
    dispatch('initBills')
    dispatch('initExpenses')
  },

  initPayPeriod ({ commit }) {
    const search = window.location.search

    if (search && search.match(/payPeriod=/)) {
      const payPeriod = search.match(/payPeriod=(\d)/)[1]
      commit('currentPayPeriod', parseInt(payPeriod))
    } else {
      Api.get("/current_pay_period")
        .then(({ data }) => commit('currentPayPeriod', data.attributes.current))
    }
  },

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

  initBills ({ commit }) {
    Api.get(`/bills`)
      .then(({ data }) => {
        for (const { id, attributes } of data) {
          commit('bills', { id, ...attributes })
        }
      })
  },

  initExpenses ({ commit }) {
    Api.get(`/expenses`)
      .then(({ data }) => {
        for (const { id, attributes } of data) {
          commit('expenses', { id, ...attributes })
        }
      })
  },

  updateIncome ({ commit }, payload) {
    Api.patch("/income", payload)
      .then(() => commit('incomePerPeriod', payload))
  },

  createBill ({ commit }, payload) {
    Api.post('/bills', payload)
      .then(({ data: { id, attributes } }) => {
        commit('bills', { id, ...attributes })
      })
  },

  updateBill ({ state, commit }, payload) {
    Api.patch(`/bills/${state.editingBill.id}`, payload)
      .then(() => {
        commit('bills', { id: state.editingBill.id, ...payload.bill })
        commit('editingBill', null)
      })
  },

  editBill ({ commit }, bill) {
    commit('editingBill', bill)
  },

  deleteBill ({ commit }, bill) {
    Api.delete(`/bills/${bill.id}`)
      .then(() => {
        commit('bills', { id: bill.id, _delete: true })
      })
  },

  createExpense ({ commit }, payload) {
    Api.post('/expenses', payload)
      .then(({ data: { id, attributes } }) => {
        commit('expenses', { id, ...attributes })
      })
  },

  updateExpense ({ state, commit }, payload) {
    Api.patch(`/expenses/${state.editingExpense.id}`, payload)
      .then(() => {
        commit('expenses', { id: state.editingExpense.id, ...payload.expense })
        commit('editingExpense', null)
      })
  },

  editExpense ({ commit }, expense) {
    commit('editingExpense', expense)
  },

  deleteExpense ({ commit }, expense) {
    Api.delete(`/expenses/${expense.id}`)
      .then(() => {
        commit('expenses', { id: expense.id, _delete: true })
      })
  }
}