class @AuthController
  constructor: (@app) ->
    @initHTML()
    @registerEvents()

  initHTML: () ->
    @$root = $('.section-login')
    @$form  = @$root.find('form')
    @$uname = @$root.find('input[name=username]').val('vinnie-pepi')
    @$pass  = @$root.find('input[name=password]')
    @$login = @$root.find('.btn-login')
    
  chromeStorageTest: () ->
    chrome.storage.local.set({"randomness": {"level": 25 }})
    level = chrome.storage.local.get "randomness", (result) ->
      console.log result

  registerEvents: () ->
    @$form.submit (e) =>
      e.preventDefault()
    @$login.click (e) =>
      e.preventDefault()
      @initOctokat()

  initOctokat: (uname, pass) ->
    uname = @$uname.val()
    pass  = @$pass.val()
    octo = new Octokat
      username: uname
      password: pass
    @app.onLogin octo
