if chrome.storage
  storageStrategy = new Backbone.ChromeStorage("IssueCollection", "sync")
else
  storageStrategy = new Backbone.LocalStorage("IssueCollection")

@IssueModel = Backbone.Model.extend
  star:() ->

  unstar: () ->

  setReminder: (time) ->

  unsetReminder: () ->

@IssueCollection = Backbone.Collection.extend
  initialize: (models, options) ->
    if options.octo? then @octo = options.octo
    Backbone.Collection.prototype.initialize.call(@, models, options)

  model: IssueModel

  fetch: (type) ->
    @octo.issues.fetch({ "filter": type })
      .done (results) =>
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
