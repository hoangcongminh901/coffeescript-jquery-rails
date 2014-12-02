class TodoApp
  constructor: ->
    @bindEvents()

  bindEvents: ->
    $("#new-todo").on "keyup", @create

  create: (e)->
    $input = $(@)
    val = $.trim $input.val()
    return unless e.which == 13 and val
    alert val
    #We create the todo item

$ ->
  app = new TodoApp()