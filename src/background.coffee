@octo = null

@clearOctokat = =>
  @octo = null

@initOctokat = (params) =>
  @octo = new Octokat(params)

@appendNotification = (id, timestamp, title, message, cb) ->
  console.log "notifications"
  getNotifications (notifications) ->
    notifications[id] =
      timestamp: timestamp,
      title: title
      message: message
    setNotifications(notifications)
    cb()

setNotifications = (notifications) ->
  console.log "set", notifications
  @Storage.set 'notifications', notifications

getNotifications = (cb) ->
  @Storage.get 'notifications', (res) ->
    notifications = res.notifications || {}
    cb(notifications)

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
  getNotifications (notifications) ->
    now = Date.now()
    for id, notification of notifications
      if now > notification.timestamp
        showNotification(notification.title, notification.message)
        delete notifications[id]
        setNotifications(notifications)
, 1000
