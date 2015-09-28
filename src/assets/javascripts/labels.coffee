class @LabelFilter
  constructor: (@$root, @coll) ->

class @Labels
  TMPL = """
    <span class="issue-label" style="background-color: #<%= color %>;">
      <%= name %>
    </span>
  """

  constructor: (@$root, @labels) ->
    @renderLabels()

  renderLabels: () ->
    for label in @labels
      @renderLabel(label)

  renderLabel: (label) ->
    html = Utils.tmplFn TMPL, label
    @$root.append(html)

