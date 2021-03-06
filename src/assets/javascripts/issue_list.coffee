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
      <h3 class="issue-title">
        <a class="issue-link" href="<%= link %>" target="_blank">
          <%= title %>
        </a>
      </h3>
      <div class="container-issue-details">
        <div class="container-right pull-right">
          <span class="date"><%= date %></span>
          <span class="issue-notif fa fa-calendar-o" />
        </div>
        <div class="issue-labels"></div>
      </div>
    </li>
  """

  constructor: (@$root, @model, @nc) ->

  dateDisplay: () ->
    d = new Date @model.get('createdAt')
    return d.toLocaleDateString()

  star: ($star) ->
    $star.removeClass('fa-star-o')
      .addClass('fa-star')

  unstar: ($star) ->
    $star.addClass('fa-star-o')
      .removeClass('fa-star')

  attachEvents: ($html) ->
    $star = $html.find('.issue-star')
    $notif = $html.find('.issue-notif')
    $issueLink = $html.find('.issue-link')

    $issueLink.click (e) =>
      e.preventDefault()
      chrome.tabs.create
        url: @model.get('link')

    $star.click () =>
      if (@model.get('starred'))
        @unstar($star)
        @model.unstar()
      else
        @star($star)
        @model.star()

    $notif.click () =>
      @nc.open(@model)

  render: () ->
    starType = if @model.get('starred') then 'fa-star' else 'fa-star-o'
    locals =
      title: @model.get('title')
      date: @dateDisplay()
      starType: starType
    $html = $(tmplFn TMPL, locals)
    @attachEvents($html)
    new Labels($html.find('.issue-labels'), @model.get('labels'))
    @$root.append $html

class @StarredList
  TMPL = """
    <ul class="list-starred">
      <li class="repo">
        <ul class="list-issues">
        </ul>
      </li>
    </ul>
  """
  constructor: (@$root, @collection, @nc) ->

  render: () ->
    coll = @collection.where({ starred: true })

    $html = $(tmplFn TMPL, {})
    $issueListRoot = $html.find('.list-issues')
    @$root.html $html

    for starred in coll
      model = @collection.findWhere({ id: starred.id })
      issueItem = new IssueItem($issueListRoot, model, @nc)
      issueItem.render()


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

  constructor: (@$root, @collection, @nc) ->

  render: () ->
    console.debug @collection
    grouped = @collection.groupBy('repo')
    for repo, items of grouped
      $html = $(tmplFn TMPL, { repoName: repo })
      $issueListRoot = $html.find('.list-issues')
      @$root.append $html
      items.forEach (item) =>
        model = @collection.findWhere({ id: item.id })
        issueItem = new IssueItem($issueListRoot, model, @nc)
        issueItem.render()
