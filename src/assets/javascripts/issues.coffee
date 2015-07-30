@IssueModel = Backbone.Model.extend
  defaults: {
    "starred": false
    "reminder": false
  }
  star: () ->
    @set { 'starred': true }

  unstar: () ->
    @set { 'starred': false }

  setReminder: (time) ->

  unsetReminder: () ->

@IssueCollection = Backbone.Collection.extend
  initialize: (models, options) ->
    console.log(options)
    if options.octo? then @octo = options.octo
    Backbone.Collection.prototype.initialize.call(@, models, options)

  model: IssueModel

  fetch: (type) ->
    @octo
      .issues
      .fetch({ "filter": type })
      .then (results) =>
        models = []
        for result in results
          models.push new IssueModel
            id: result.id
            title: result.title
            link: result.htmlUrl
            createdAt: result.createdAt
            updatedAt: result.updatedAt
            repo: result.repository.fullName
        @add(models)
