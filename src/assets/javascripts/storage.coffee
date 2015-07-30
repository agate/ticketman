
@Storage =
  isChrome: (typeof chrome.storage) != 'undefined'

  # storage: (if Storage.isChrome then chrome.storage.local else localStorage)
  storage: chrome.storage.local

  get: (id, cb) ->
    Storage.storage.get id, cb

  set: (id, payload) ->
    obj = {}
    obj[id] = payload
    console.log obj
    Storage.storage.set obj
