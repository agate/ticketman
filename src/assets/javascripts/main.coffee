$ ->
  new App()

  $('button.notifyme').click ->
    id = "ticketman-notification-#{Date.now()}"
    opt =
      type: "basic"
      title: "Primary Title"
      message: "Primary message to display"
      iconUrl: "images/ticketman128.png"

    chrome.notifications.create id, opt, ->
      console.log('shown :D')
