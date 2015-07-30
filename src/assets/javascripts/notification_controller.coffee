class @NotificationController
  constructor: (@$root, @app) ->
    @initHTML()
    @registerEvents()

  initHTML: ->
    @$btnCancel = @$root.find('.btn.cancel')
    @$btnSet = @$root.find('.notif-option')

  registerEvents: ->
    @$btnCancel.click =>
      @close()
    @$btnSet.click (e) =>
      console.log e.target.className
      @set('later-today')
      @close()

  open: (@model) ->
    @app.showModal()
    @$root.show()

  close: () ->
    @app.hideModal()
    @$root.hide()

  set: (type) ->
    # type = @$root.find('.notif-option input:checked').val()
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
      "#{@model.get('title')}",
      '<a href="#{@model.get('link')}">#{@model.get('link')}</a>',
      =>
        @close()
    )
