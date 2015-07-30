
Storage =
  storage: chrome.storage.local

  get: (q, cb) ->
    @storage.get q, cb

  setId: (id, payload) ->
    payload = { id: payload }
    @storage.set payload
