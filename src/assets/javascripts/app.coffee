class @App
  constructor: () ->
    @initHTML()
    @authController = new AuthController(@)
    
  initHTML: () ->
    @$sectionLogin = $('.section-login')
    @$sectionMain  = $('.section-main')
    @$sectionLoad  = $('.section-loading')
    @$sectionNotif = $('.section-notification')
    @$screens      = $('.screen').hide()
    @$screenModal  = $('.screen-modal')
    @$tabSections  = $('.tab-section')

    if @octo() then @onLogin() else @showLogin()

  octo: () ->
    chrome.extension.getBackgroundPage().octo

  showModal: () ->
    @$screenModal.height(document.documentElement.clientHeight)
    @$screenModal.width(document.documentElement.clientWidth)
    @$screenModal.show()

  hideModal: () ->
    @$screenModal.hide()

  showLogin: () ->
    @$screens.hide()
    @$sectionLogin.show()

  showMain: () ->
    @$screens.hide()
    @$sectionMain.show()

  showLoading: () ->
    @$screens.hide()
    @$sectionLoad.show()

  onLogin: () ->
    @notificationController = new NotificationController(@$sectionNotif, @)
    @assignedIssues = new IssueCollection [], { octo: @octo() }
    @assignedIssues.fetch('assigned')

    @assignedIssues.on 'update', () =>
      $assigned = @$tabSections.filter('.assigned').show()
      list = new IssueList($assigned, @assignedIssues, @notificationController)
      list.render()
      @showMain()
