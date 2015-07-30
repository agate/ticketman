class @NotificationController
  constructor: (@$root, @app) ->

  open: (id) ->
    @$root.height(document.documentElement.clientHeight)
    @$root.width(document.documentElement.clientWidth)
    @$root.show()

  close: () ->
    @$root.hide()
