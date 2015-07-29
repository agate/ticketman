$ ->
  new App()

  $('button.notifyme').click ->
    # notify after 5 seconds
    at = Date.now() + 5000
    chrome.extension.getBackgroundPage().notify
      title: "title@#{at}"
      message: "message@#{at}"
      at: at
