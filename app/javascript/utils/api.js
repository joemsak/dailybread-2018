const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes["content"].nodeValue
const VERSION_PATH = "/v1"

export default {
  get (uri) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        headers: {
          'x-access-token': window.localStorage.getItem('jwt'),
        },
      }
    ).then(resp => {
      if (resp.status === 401) {
        window.location.href = "/signin"
      } else {
        return resp.json()
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
          'x-access-token': window.localStorage.getItem('jwt'),
        },
        body: JSON.stringify(payload),
      }
    ).then(resp => {
      if (resp.status === 401) {
        window.location.href = "/signin"
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
          'x-access-token': window.localStorage.getItem('jwt'),
        },
        body: JSON.stringify(payload),
      }
    ).then(resp => {
      if (resp.status === 401 || resp.status === 404) {
        window.location.href = "/signin"
      } else if (resp.status === 302) {
        resp.json().then((json) => {
          window.location.href = json.redirectTo
        })
      } else {
        return resp.json()
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
          'x-access-token': window.localStorage.getItem('jwt'),
        },
      }
    ).then(resp => {
      if (resp.status === 401) {
        window.location.href = "/signin"
      }
    })
  }
}