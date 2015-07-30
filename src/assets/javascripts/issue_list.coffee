class @IssueItem
  constructor: (model) ->

class @IssueList
  ISSUE_TYPE = 'assigned'
  TMPL = jade.compile """
    ul.list-repo
      li.repo 
        h2= repoName
        ul.list-issues
  """

  constructor: (collection) ->
