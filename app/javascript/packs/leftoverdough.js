/* eslint no-console: 0 */
import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

Vue.use(Vue2Filters)

import Api from 'utils/api'

import App from '../app.vue'
import router from 'routes'
import store from 'store'

function initApp (el) {
  new Vue({
    el,
    store,
    router,
    render: h => h(App),
  })
}

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.querySelector("#leftoverdough-app")
  const search = window.location.search
  const jwt = window.localStorage.getItem('jwt')

  if (window.location.pathname.match(/signin|signup/)) {
    return false
  } else if (window.location.pathname.match(/logout/)) {
    window.localStorage.removeItem('jwt')
    window.location.href = '/signin'
    return false
  } else if (search && search.match(/magicLinkToken=/)) {
    const token = search.match(/magicLinkToken=(\w+)/)[1]

    Api.post('/access_tokens', { token })
      .then(json => {
        window.localStorage.setItem('jwt', json.jwt)
        window.history.replaceState(null, null, window.location.pathname)
        initApp(el)
        return false
      })
  } else if (search && search.match(/emailConfirmationToken=/)) {
    const token = search.match(/emailConfirmationToken=(\w+)/)[1]

    Api.post('/email_confirmations', { token })
      .then(json => {
        window.localStorage.setItem('jwt', json.jwt)
        window.history.replaceState(null, null, window.location.pathname)
        initApp(el)
        return false
      })
  } else if (el && jwt) {
    initApp(el)
    return false
  } else {
    window.location.href = '/signin'
  }
})