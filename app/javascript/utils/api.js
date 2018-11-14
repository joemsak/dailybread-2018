const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes["content"].nodeValue
const VERSION_PATH = "/v1"

export default {
  get (uri) {
    return fetch(`${VERSION_PATH}${uri}`).then(resp => resp.json())
  },

  patch (uri, payload) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "PATCH",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(payload),
      }
    )
  },

  post (uri, payload) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(payload),
      }
    ).then(resp => resp.json())
  },

  delete (uri) {
    return fetch(
      `${VERSION_PATH}${uri}`,
      {
        method: "DELETE",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
      }
    )
  }
}