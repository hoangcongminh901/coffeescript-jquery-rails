toggleItem = (el) ->
  $li = $(el).closest("li").toggleClass "completed"
  id = $li.data "id"

  data = "todo_item[completed]=#{el.checked}"
  url = "todo_items/#{id}"

  $.ajax
    type: "PUT"
    url: url
    data: data

destroyItem = (elem) ->
  $li = $(elem).closest('li')
  id = $li.data 'id'
  url = "/todo_items/#{id}"
  $.ajax
    url: url
    type: 'DELETE'
    success: ->
      $li.remove()

clearItems = (el) ->
  $.ajax
    url: "todo_items/clear_all"
    type: "GET"
    success: ->
      $("#todo-list").remove()

$ ->
  $("#todo-list").on "change", ".toggle", (e) -> toggleItem e.target
  $("#todo-list").on 'click', '.destroy', (e) -> destroyItem e.target
  $("#clear-completed").on "click", (e) -> clearItems e.target