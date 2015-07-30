notifications = {}
@octo = null

@notify = (opts) ->
  notifications[Date.now()] = opts

@clearOctokat = =>
  @octo = null
@initOctokat = (params) =>
  @octo = new Octokat(params)

showNotification = (title, message) ->
  id = "ticketman-notification-#{Date.now()}"
  opt =
    type: "basic"
    title: title
    message: message
    iconUrl: "images/ticketman128.png"
  chrome.notifications.create id, opt, ->
    console.log('shown :D')

setInterval ->
  now = Date.now()
  for id, notification of notifications
    if now > notification.at
      showNotification(notification.title, notification.message)
      delete notifications[id]
, 1000
