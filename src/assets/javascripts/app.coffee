class @App
  constructor: () ->
    @$sectionLogin = $('.section-login')
    @$sectionMain = $('.section-main').hide()
    @authController = new AuthController(@)

    $btnBack = $('button.back')
    $btnBack.click =>
      @showLogin()
    
  showMain: () ->
    @$sectionLogin.hide()
    @$sectionMain.show()

  showLoading: () ->

  showLogin: () ->
    @$sectionLogin.show()
    @$sectionMain.hide()

  onLogin: (octo) ->
    @coll = new IssueCollection [], { octo: octo }
    @coll.fetch('assigned')
    @coll.on 'update', () =>
      @showMain()
    window.coll = @coll

