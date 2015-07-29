class @AuthController
  constructor: (@app) ->
    @initHTML()
    @registerEvents()

  initHTML: () ->
    @$root = $('.section-login')
    @$uname = @$root.find('input[name=username]')
    @$pass  = @$root.find('input[name=password]')
    @$login = @$root.find('.login')
    @$btnLogin = @$root.find('button.login')

  registerEvents: () ->
    @$login.click () =>
      uname = @$uname.val()
      pass  = @$pass.val()
      @initOctokat(uname, pass)
    @$btnLogin.click =>
      @app.showMain()

  initOctokat: (uname, pass) ->
    @octo = new Octokat
      username: uname
      password: pass
    @fetchIssues('assigned')

  fetchIssues: (type) ->
    @octo.issues.fetch({ "filter": type })
      .done (results) ->
        console.log results
