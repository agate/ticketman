class @AuthController
  constructor: (@app) ->
    @initHTML()
    @registerEvents()

  initHTML: () ->
    @$root   = $('.section-login')
    @$form   = @$root.find('form')
    @$uname  = @$root.find('input[name=username]')
    @$pass   = @$root.find('input[name=password]')
    @$login  = @$root.find('.btn-login')
    @$logout = $('.btn-log-out')
    
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
    @$logout.click (e) =>
      e.preventDefault()
      chrome.extension.getBackgroundPage().clearOctokat()
      @clearForm()
      @app.showLogin()
      @$uname.focus()

  clearForm: ->
    @$uname.val('')
    @$pass.val('')

  initOctokat: (uname, pass) ->
    uname = @$uname.val()
    pass  = @$pass.val()
    chrome.extension.getBackgroundPage().initOctokat(
      username: uname
      password: pass
    )
    @app.onLogin()
