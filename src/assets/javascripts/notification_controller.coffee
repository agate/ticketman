class @NotificationController
  constructor: (@$root, @app) ->
    @initHTML()
    @registerEvents()

  initHTML: ->
    @$btnCancel = @$root.find('.btn.cancel')
    @$btnSet = @$root.find('.btn.set')

  registerEvents: ->
    @$btnCancel.click =>
      @close()
    @$btnSet.click =>
      @set()

  open: (@id) ->
    @app.showModal()
    @$root.show()

  close: () ->
    @app.hideModal()
    @$root.hide()

  set: ->
    type = @$root.find('.notif-option input:checked').val()
    at = Date.now() + switch type
      when 'later-today'
        5 * 1000
      when 'tomorrow'
        30 * 1000
      when 'later-this-week'
        60 * 1000

    chrome.extension.getBackgroundPage().appendNotification(
      @id,
      at,
      "title for #{@id}",
      "message for #{@id}",
      =>
        @close()
    )
