class @NotificationController
  constructor: (@$root, @app) ->

  open: (id) ->
    @app.showNotifications()
