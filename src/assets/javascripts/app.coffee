class @App
  constructor: () ->
    @initHTML()
    @authController = new AuthController(@)
    
  initHTML: () ->
    @$sectionLogin = $('.section-login').hide()
    @$sectionMain  = $('.section-main').hide()
    @$tabSections = $('.tab-section')

    if @octo() then @onLogin() else @showLogin()

  octo: () ->
    chrome.extension.getBackgroundPage().octo

  showLogin: () ->
    @$sectionLogin.show()
    @$sectionMain.hide()

  showMain: () ->
    @$sectionLogin.hide()
    @$sectionMain.show()

  onLogin: () ->
    @showMain()

    @assignedIssues = new IssueCollection [], { octo: @octo() }
    @assignedIssues.fetch('assigned')

    @assignedIssues.on 'update', () =>
      $assigned = @$tabSections.filter('.assigned').show()
      list = new IssueList($assigned, @assignedIssues)
      list.render()
