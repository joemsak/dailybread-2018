import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import Expenses from 'components/Expenses'
import Bills from 'components/Bills'

export const routes = [
  { path: '/', component: Expenses },
  { path: '/bills', component: Bills },
]

export default new VueRouter({
  routes,
})