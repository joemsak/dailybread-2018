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

let refreshJWTIntervalId

window.addEventListener('focus', autoRefreshJWT)

window.addEventListener('blur', () => {
  clearInterval(refreshJWTIntervalId)
  refreshJWTIntervalId = 0
})

function autoRefreshJWT () {
  if (!refreshJWTIntervalId) {
    const expireStr = window.sessionStorage.getItem('jwtExpiresAt')

    const expiry = parseInt(expireStr) - 10 // minus 10 seconds
    const now = Math.floor(new Date().getTime() / 1000)

    const milliseconds = (expiry - now) * 1000

    if (milliseconds > 0)
      refreshJWTIntervalId = setInterval(refreshJWT, milliseconds)
    } else {
      window.location.href = "/signin?msg=\
        Your session is invalid or has \
        expired after 10 minutes of inactivity. \
        Please sign in."
  }
}

function refreshJWT () {
  const refreshToken = window.sessionStorage.getItem('refreshToken')
  Api.post('/access_token_refreshes', { token: refreshToken })
    .then(json => setJWT(json))
}

function setJWT (json) {
  window.sessionStorage.setItem('jwt', json.jwt)
  window.sessionStorage.setItem('jwtExpiresAt', json.expiresAt)
  window.sessionStorage.setItem('refreshToken', json.refreshToken)
  clearInterval(refreshJWTIntervalId)
  autoRefreshJWT()
}

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.querySelector("#leftoverdough-app")
  const search = window.location.search
  const jwt = window.sessionStorage.getItem('jwt')

  if (window.location.pathname.match(/signin|signup|users/)) {
    return false

  } else if (window.location.pathname.match(/logout/)) {
    window.sessionStorage.removeItem('jwt')
    window.location.href = '/signin'
    return false

  } else if (search && search.match(/magicLinkToken=/)) {
    const token = search.match(/magicLinkToken=(\w+)/)[1]

    Api.post('/access_tokens', { token })
      .then(json => {
        setJWT(json)
        window.history.replaceState(null, null, window.location.pathname)
        initApp(el)
        return false
      })

  } else if (search && search.match(/emailConfirmationToken=/)) {
    const token = search.match(/emailConfirmationToken=(\w+)/)[1]

    Api.post('/email_confirmations', { token })
      .then(json => {
        setJWT(json)
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