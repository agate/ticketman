class @App
  constructor: () ->
    @$sectionLogin = $('.section-login')
    @$sectionMain  = $('.section-main').hide()
    @authController = new AuthController(@)
    @initHTML()

    $btnBack = $('button.back')
    $btnBack.click =>
      @showLogin()
    
  initHTML: () ->
    @$tabSections = $('.tab-section')

  showMain: () ->
    @$sectionLogin.hide()
    @$sectionMain.show()

  
  showLoading: () ->

  showLogin: () ->
    @$sectionLogin.show()
    @$sectionMain.hide()

  onLogin: (octo) ->
    @assignedIssues = new IssueCollection [], { octo: octo }
    @assignedIssues.fetch('assigned')

    @assignedIssues.on 'update', () =>
      @showMain()
      $assigned = @$tabSections.filter('.assigned').show()
      list = new IssueList($assigned, @assignedIssues)
      list.render()

