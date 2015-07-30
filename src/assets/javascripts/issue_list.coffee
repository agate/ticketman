class @IssueItem
  JADE_TMPL = jade.compile """
    span.issue-star.fa.fa-lg(class="fa-star-o")
    h3.issue-title= title
    .container-issue-details
      .container-right.pull-right
        span.date= date 
        span.fa.fa-calendar-o
  """
  TMPL = _.template """
    <span class="issue-star fa fa-lg <%= starType %>" />
    <h3 class="issue-title"><%= title %></h3>
    <div class="container-issue-details">
      <div class="container-right pull-right">
        <span class="date"><%= date %></span>
        <span class="fa fa-calendar-o" />
      </div>
    </div>
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
    $html = $(TMPL(locals))
    @attachEvents($html)
    @$root.append $html
    


class @IssueList
  ISSUE_TYPE = 'assigned'

  TMPL = _.template """
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
      $html = $(TMPL({ repoName: repo }))
      $issueListRoot = $html.find('.list-issues')
      @$root.append $html
      items.forEach (item) =>
        model = @collection.findWhere({ id: item.id })
        issueItem = new IssueItem($issueListRoot, model)
        issueItem.render()
        
