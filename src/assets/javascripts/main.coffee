$ ->
  $('strong.message').click ->
    $(@).text('clicked' + Date.now())
