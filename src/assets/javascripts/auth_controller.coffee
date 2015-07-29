class @AuthController
  constructor: () ->
    @initHTML()
    @registerEvents()

  initHTML: () ->
    @$root = $('.section-login')
    @$uname = @$root.find('input[name=username]')
    @$pass  = @$root.find('input[name=password]')
    @$login = @$root.find('.login')

  registerEvents: () ->
    @$login.click () =>
      uname = @$uname.val()
      pass  = @$pass.val()
      @initOctokat(uname, pass)

  initOctokat: (uname, pass) ->
    @octo = new Octokat
      username: uname
      password: pass
    @fetchIssues('assigned')

  fetchIssues: (type) ->
    @octo.issues.fetch({ "filter": type })
      .done (err, results) ->
        console.log(err, results)


