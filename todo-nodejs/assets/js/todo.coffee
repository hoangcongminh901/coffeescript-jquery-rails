Storage::setObj = (key, obj)->
  localStorage.setItem key, JSON.stringify(obj)
Storage::getObj = (key)->
  $.parseJSON this.getItem(key)

class TodoApp
  constructor: ->
    @cacheElements()
    @bindEvents()
    @displayItems()

  cacheElements: ->
    @$input = $("#new-todo")
    @$todoList = $("#todo-list")
    @$clearButton = $("#clear-completed")
    @$joinListName = $("#join-list-name")
    @$join = $("#join")
    @$connect = $('#connect')
    @$disconnect = $('#disconnect')
    @$connectedList = $('#connected-list')
    @$leave = $('#leave')

  bindEvents: ->
    @$input.on "keyup", (e) => @create(e)
    @$todoList.on "click", ".destroy", (e) => @destroy(e.target)
    @$todoList.on "change", ".toggle", (e) => @toggle(e.target)
    @$clearButton.on "click", (e) => @clear()
    @$join.on "click", (e) => @joinList()
    @$leave.on 'click', (e) => @leaveList()

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

  joinList: ->
    @socket = io.connect "http://localhost:3001"
    @socket.on "connect", =>
      @currentList = @$joinListName.val()
      @socket.emit "joinList", @$joinListName.val()
    @socket.on "syncItems", (items) =>
      @syncItems(items)

  syncItems: (items) ->
    console.log "syncing items"
    localStorage.clear()
    localStorage.setObj item.id, item for item in items
    @displayItems()
    @displayConnected(@currentList)

  displayConnected: (listName) ->
    @$disconnect.removeClass 'hidden'
    @$connectedList.text listName
    @$connect.addClass 'hidden'

  leaveList: ->
    @socket.disconnect() if @socket
    @displayDisconnected()

  displayDisconnected: () ->
    @$disconnect.addClass 'hidden'
    @$connect.removeClass 'hidden'

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