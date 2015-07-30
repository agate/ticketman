class @IssueItem
  TMPL = jade.compile """
    i.issue-star.fa.fa-lg(class="fa-star-o")
    h3.issue-title= title
    .container-issue-details
      .container-right.pull-right
        span.date= date 
        span.fa.fa-calendar-o
  """

  constructor: (@$root, @model) ->

  dateDisplay: () ->
    d = new Date(@model.get('createdAt'))
    return d.toLocaleDateString()

  attachEvents: ($html) ->

  render: () ->
    locals =
      title: @model.get('title')
      date: @dateDisplay()
    $html = $(TMPL(locals))
    attachEvents($html)
    @$root.append $html
    


class @IssueList
  ISSUE_TYPE = 'assigned'
  TMPL = jade.compile """
    ul.list-repo
      li.repo 
        h2= repoName
        ul.list-issues
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
        
        
    
