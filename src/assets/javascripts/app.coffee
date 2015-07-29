class @App
  constructor: () ->
    @$sectionLogin = $('.section-login')
    @$sectionMain = $('.section-main').hide()
    @authController = new AuthController(@)

    $btnBack = $('button.back')
    $btnBack.click =>
      @showLogin()
    
  showMain: () ->
    $sectionLogin.hide()
    $sectionMain.show()

  showLogin: () ->
    @$sectionLogin.show()
    @$sectionMain.hide()

