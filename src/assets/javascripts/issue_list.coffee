class @IssueItem
  TMPL = jade.compile """
    i.fa.fa-star-o.fa-lg
    h3.issue-title= title
    .container-issue-details
      .container-right.pull-right
        span.date= date 
        span.fa.fa-calendar-o
  """

  constructor: (@$root, @model) ->

  render: () ->
    locals =
      title: @model.get('title')
      date: @model.get('createdAt')
    @$root.append TMPL(locals)
    


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
        
        
    
