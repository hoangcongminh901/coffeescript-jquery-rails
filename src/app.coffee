Storage::setObj = (key, obj)->
  @setItem key, JSON.stringify(obj)
Storage::getObj = (key)->
  JSON.parse @getItem(key)

class TodoApp
  constructor: ->
    @cacheElements()
    @bindEvents()

  cacheElements: ->
    @$input = $("#new-todo")

  bindEvents: ->
    @$input.on "keyup", (e) => @create(e)

  displayItems: ->
    alert 'displaying items'

  create: (e)->
    val = $.trim @$input.val()
    return unless e.which == 13 and val

    randomId = (Math.floor Math.random()*999999)

    localStorage.setObj randomId, {
      id: randomId
      title: val
      completed: false
    }

    @$input.val ""
    @displayItems()

$ ->
  app = new TodoApp()