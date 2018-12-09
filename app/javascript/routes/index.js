import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Expenses from 'components/Expenses'
import Bills from 'components/Bills'
import Income from 'components/Income'
import ManageSubscription from 'components/ManageSubscription'

import store from 'store'

const requireIncome = (to, _from, next) => {
  if (store.state.appReady && !store.state.incomePerPeriod.id) {
    next('/income')
  } else {
    next()
  }
}

export const routes = [
  {
    path: '/',
    component: Expenses,
    beforeEnter: requireIncome,
  },

  {
    path: '/bills',
    component: Bills,
    beforeEnter: requireIncome,
  },

  { path: '/income', component: Income },

  { path: '/subscription', component: ManageSubscription },

  {
    path: '/logout',
    beforeEnter: () => {
      window.sessionStorage.removeItem('jwt')
      window.location.href = "/signin"
    }
  }
]

export default new VueRouter({
  routes,
})