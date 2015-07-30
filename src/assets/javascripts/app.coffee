class @App
  constructor: () ->
    @initHTML()
    @authController = new AuthController(@)
    
  initHTML: () ->
    @$sectionLogin = $('.section-login')
    @$sectionMain  = $('.section-main')
    @$sectionLoad  = $('.section-loading')
    @$screens      = $('.screen').hide()
    @$tabSections  = $('.tab-section')

    if @octo() then @onLogin() else @showLogin()

  octo: () ->
    chrome.extension.getBackgroundPage().octo

  showLogin: () ->
    @$screens.hide()
    @$sectionLogin.show()
    # @$sectionMain.hide()

  showMain: () ->
    # @$sectionLogin.hide()
    @$screens.hide()
    @$sectionMain.show()

  showLoading: () ->
    @$screens.hide()
    @$sectionLoad.show()

  onLogin: () ->

    @assignedIssues = new IssueCollection [], { octo: @octo() }
    @assignedIssues.fetch('assigned')

    @assignedIssues.on 'update', () =>
      $assigned = @$tabSections.filter('.assigned').show()
      list = new IssueList($assigned, @assignedIssues)
      list.render()
      @showMain()
