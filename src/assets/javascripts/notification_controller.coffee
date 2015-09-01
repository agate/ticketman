class @NotificationController
  constructor: (@$root, @app) ->
    @initHTML()
    @registerEvents()

  initHTML: ->
    @$btnCancel = @$root.find('.btn.cancel')

  registerEvents: ->
    @$btnCancel.click =>
      @close()
    @$root.find('.btn.notif-option').click (e) =>
      @set(e.target)

  open: (@model) ->
    @app.showModal()
    @$root.show()

  close: () ->
    @app.hideModal()
    @$root.hide()

  set: (target) ->
    at = Date.now() + switch $(target).data('type')
      when 'later-today'
        120 * 60 * 1000
      when 'tomorrow'
        24 * 60 * 1000
      when 'next-week'
        7* 24 * 60 * 1000
    link = @model.get('link')
    id   = @model.get('id')

    chrome.extension.getBackgroundPage().appendNotification(
      id,
      at,
      "#{@model.get('title')}",
      "<a href=\"#{@model.get('link')}\">#{@model.get('link')}</a>",
      =>
        @close()
    )
