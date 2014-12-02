Storage::setObj = (key, obj)->
  @setItem key, JSON.stringify(obj)
Storage::getObj = (key)->
  JSON.parse @getItem(key)

class TodoApp
  constructor: ->
    @cacheElements()
    @bindEvents()
    @displayItems()

  cacheElements: ->
    @$input = $("#new-todo")
    @$todoList = $("#todo-list")
    @$clearButton = $("#clear-completed")

  bindEvents: ->
    @$input.on "keyup", (e) => @create(e)
    @$todoList.on "click", ".destroy", (e) => @destroy(e.target)
    @$todoList.on "change", ".toggle", (e) => @toggle(e.target)
    @$clearButton.on "click", (e) => @clear()

  clear: ->
    @clearItems()
    localStorage.clear()

  toggle: (e) ->
    id = $(e).closest("li").data "id"
    item = localStorage.getObj id
    item.completed = !item.completed
    localStorage.setObj id, item

  destroy: (e) ->
    id = $(e).closest("li").data "id"
    localStorage.removeItem id
    @displayItems()

  displayItems: ->
    @clearItems()
    @addItem(localStorage.getObj(id)) for id in Object.keys(localStorage)

  clearItems: ->
    @$todoList.empty()

  addItem: (item) ->
    html = """
      <li #{if item.completed then 'class="completed"' else ''} data-id="#{item.id}">
        <div class="view">
          <input class="toggle" type="checkbox" #{if item.completed then "checked" else ""}>
          <label>#{item.title}</label>
          <button class="destroy"></button>
        </div>
      </li>
    """
    @$todoList.append(html)


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