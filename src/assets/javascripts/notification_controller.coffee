class @NotificationController
  constructor: (@$root, @app) ->

  open: (id) ->
    @app.showModal()
    @$root.show()

  close: () ->
    @app.hideModal()
    @$root.hide()
