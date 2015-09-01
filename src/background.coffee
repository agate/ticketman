@octo = null

@clearOctokat = =>
  @octo = null

@initOctokat = (params) =>
  @octo = new Octokat(params)

@appendNotification = (id, timestamp, title, message, link, cb) ->
  console.log "notifications"
  getNotifications (notifications) ->
    notifications[id] =
      timestamp: timestamp,
      title: title
      message: message
      link: link
    setNotifications(notifications)
    cb()

setNotifications = (notifications) ->
  console.log "set", notifications
  @Storage.set 'notifications', notifications

getNotifications = (cb) ->
  @Storage.get 'notifications', (res) ->
    notifications = res.notifications || {}
    cb(notifications)

showNotification = (title, message, link) ->
  id = "ticketman-notification-#{link}"
  opt =
    type: "basic"
    title: title
    message: message
    iconUrl: "images/ticketman128.png"
    buttons: [
      { title: "Go to this ticket's page" }
    ]
  chrome.notifications.create id, opt, ->

setInterval ->
  getNotifications (notifications) ->
    now = Date.now()
    for id, notification of notifications
      if now > notification.timestamp
        showNotification(notification.title, notification.message, notification.link)
        delete notifications[id]
        setNotifications(notifications)
, 1000

chrome.notifications.onClosed.addListener (notificationId, byUser) ->
chrome.notifications.onButtonClicked.addListener (notificationId, buttonIndex) ->
  m = notificationId.match(/^ticketman-notification-(.*)/)
  if m && m[1]
    chrome.tabs.create
      url: m[1]
