/* eslint no-console: 0 */
import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

Vue.use(Vue2Filters)

import App from '../app.vue'
import store from 'store'
import router from 'routes'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('dailybread'))
  new Vue({
    el,
    store,
    router,
    render: h => h(App)
  })
})