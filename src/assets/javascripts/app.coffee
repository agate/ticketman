class @App
  constructor: ->
    @initHTML()
    @authController = new AuthController(@)
    @registerEvents()

  initHTML: ->
    @$sectionLogin = $('.section-login')
    @$sectionMain  = $('.section-main')
    @$sectionLoad  = $('.section-loading')
    @$sectionNotif = $('.section-notification')
    @$screens      = $('.screen').hide()
    @$screenModal  = $('.screen-modal')
    @$tabs         = $('nav .tab')
    @$tabSections  = $('.tab-section')

    if @octo()
      @showLoading()
      @onLogin()
    else
      @showLogin()

  registerEvents: () ->
    @$tabs.click (e) =>
      @$tabs.removeClass('selected')
      $tab = $(e.currentTarget)
      $tab.addClass('selected')
      @activateTab($tab.data('tab'))

  octo: ->
    chrome.extension.getBackgroundPage().octo

  showModal: ->
    @$screenModal.height(document.documentElement.clientHeight)
    @$screenModal.width(document.documentElement.clientWidth)
    @$screenModal.show()

  hideModal: ->
    @$screenModal.hide()

  showLogin: (message=null) ->
    $message = @$sectionLogin.find('.login-message')
    if(message)
      $message.html(message).show()
    else
      $message.html('').hide()
    @$screens.hide()
    @$sectionLogin.show()

  showMain: () ->
    @$screens.hide()
    @$sectionMain.show()

  showLoading: () ->
    @$screens.hide()
    @$sectionLoad.show()

  activateTab: (tabname) ->
    @$tabSections.hide()
    if tabname == 'starred'
      $active = @$tabSections.filter('.starred').show()
      list = new StarredList($active, @assignedIssues, @notificationController)
      list.render()
    else
      $active = @$tabSections.filter(".#{tabname}").show()
    return $active

  onLogin: ->
    @notificationController = new NotificationController(@$sectionNotif, @)
    @assignedIssues = new IssueCollection [], { octo: @octo() }
    @assignedIssues.fetch('assigned')

    @assignedIssues.on 'loaded', () =>
      $assigned = @activateTab('assigned')
      list = new IssueList($assigned, @assignedIssues, @notificationController)
      list.render()
      @showMain()
