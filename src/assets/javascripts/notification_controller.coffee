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
        5 * 1000
      when 'tomorrow'
        30 * 1000
      when 'next-week'
        60 * 1000

    console.log at

    chrome.extension.getBackgroundPage().appendNotification(
      @id,
      at,
      "#{@model.get('title')}",
      "<a href=\"#{@model.get('link')}\">#{@model.get('link')}</a>",
      =>
        @close()
    )
