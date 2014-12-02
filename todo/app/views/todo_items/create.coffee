$("#new-todo").val ""
html = "<%= escape_javascript(render "todo_item", item: @todo_item) %>"
$("#todo-list").append html