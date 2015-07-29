$ ->
  $btnLogin = $('button.login')
  $btnBack = $('button.back')

  $sectionLogin = $('.section-login')
  $sectionMain = $('.section-main').hide()

  $btnLogin.click ->
    $sectionLogin.hide()
    $sectionMain.show()
  $btnBack.click ->
    $sectionLogin.show()
    $sectionMain.hide()
  authController = new AuthController()
