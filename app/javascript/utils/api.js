const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes["content"].nodeValue
const VERSION_PATH = "/v1"

function forceSignin () {
  if (window.sessionStorage.getItem('jwt')) {
    window.location.href = "/signin?msg= \
      Your session is invalid or has \
      expired after 10 minutes of inactivity. \
      Please sign in."
  } else {
    window.location.href = "/signin"
  }
}

function setSessionData(headers) {
  window.sessionStorage.setItem('jwt', headers.get('x-access-token'))
  window.sessionStorage.setItem('refreshToken', headers.get('x-access-refresh-token'))
  window.sessionStorage.setItem('jwtExpiresAt', headers.get('x-access-token-expires-at'))
}

export default {
  get (uri) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        headers: {
          'x-access-token': window.sessionStorage.getItem('jwt'),
        },
      }
    ).then(resp => {
      if (resp.status === 401) {
        forceSignin()
      } else if (resp.status === 404) {
        return resp
      } else {
        setSessionData(resp.headers)
        return resp.text().then(text => {
          return text ? JSON.parse(text) : {}
        })
      }
    })
  },

  patch (uri, payload) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "PATCH",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'x-access-token': window.sessionStorage.getItem('jwt'),
        },
        body: JSON.stringify(payload),
      }
    ).then(resp => {
      if (resp.status === 401) {
        forceSignin()
      } else {
        setSessionData(resp.headers)
        return resp.text().then(text => {
          return text ? JSON.parse(text) : {}
        })
      }
    })
  },

  post (uri, payload) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'x-access-token': window.sessionStorage.getItem('jwt'),
        },
        body: JSON.stringify(payload),
      }
    ).then(resp => {
      if (resp.status === 401 || resp.status === 404) {
        forceSignin()
      } else if (resp.status === 302) {
        resp.json().then((json) => {
          window.location.href = json.redirectTo
        })
      } else {
        setSessionData(resp.headers)
        return resp.text().then(text => {
          return text ? JSON.parse(text) : {}
        })
      }
    })
  },

  delete (uri) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "DELETE",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'x-access-token': window.sessionStorage.getItem('jwt'),
        },
      }
    ).then(resp => {
      if (resp.status === 401) {
        forceSignin()
      } else {
        setSessionData(resp.headers)
        return resp.text().then(text => {
          return text ? JSON.parse(text) : {}
        })
      }
    })
  }
}