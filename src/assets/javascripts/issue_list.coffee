tmplRe = /<%=\s*([^\s]*?)\s*%>/g
tmplFn = (str, obj) ->
  while (m = tmplRe.exec(str)) != null
    replacee = m[0]
    key = m[1]
    if (obj[key]?)
      str = str.replace(replacee, obj[key])
  return str

class @IssueItem
  TMPL = """
    <li class="issue">
      <span class="issue-star fa fa-lg <%= starType %>" />
      <h3 class="issue-title"><%= title %></h3>
      <div class="container-issue-details">
        <div class="container-right pull-right">
          <span class="date"><%= date %></span>
          <span class="fa fa-calendar-o" />
        </div>
      </div>
    </li>
  """

  constructor: (@$root, @model) ->

  dateDisplay: () ->
    d = new Date @model.get('createdAt')
    return d.toLocaleDateString()

  star: ($star) ->
    $star.removeClass('fa-star-o')
      .addClass('fa-star')
    @model.star()

  unstar: ($star) ->
    $star.addClass('fa-star-o')
      .removeClass('fa-star')
    @model.unstar()

  attachEvents: ($html) ->
    $star = $html.filter('.issue-star')
    $star.click () =>
      if (@model.get('starred'))
        @unstar($star)
      else
        @star($star)

  render: () ->
    starType = if @model.get('star') then 'fa-star' else 'fa-star-o'
    locals =
      title: @model.get('title')
      date: @dateDisplay()
      starType: starType
    $html = $(tmplFn TMPL, locals)
    @attachEvents($html)
    @$root.append $html
    


class @IssueList
  ISSUE_TYPE = 'assigned'

  TMPL = """
    <ul class="list-repo">
      <li class="repo">
        <h2><%= repoName %></h2>
        <ul class="list-issues">
        </ul>
      </li>
    </ul>
  """

  constructor: (@$root, @collection) ->

  render: () ->
    grouped = @collection.groupBy('repo')
    window.coll = @collection
    for repo, items of grouped
      $html = $(tmplFn TMPL, { repoName: repo })
      $issueListRoot = $html.find('.list-issues')
      @$root.append $html
      items.forEach (item) =>
        model = @collection.findWhere({ id: item.id })
        issueItem = new IssueItem($issueListRoot, model)
        issueItem.render()
        
