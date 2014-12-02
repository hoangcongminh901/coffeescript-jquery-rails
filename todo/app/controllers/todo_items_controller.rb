class TodoItemsController < ApplicationController
  before_action :set_todo_item, only: [:update, :destroy]

  def index
    @new_todo_item = TodoItem.new
    @todo_items = TodoItem.all
  end

  def create
    @todo_item = TodoItem.create todo_item_params
  end

  def update
    @item.update_attributes todo_item_params
    render nothing: true
  end

  def destroy
    @item.destroy
    render nothing: true
  end

  def clear_all
    TodoItem.delete_all
    render nothing: true
  end

  private
  def set_todo_item
    @item = TodoItem.find params[:id]
  end

  def todo_item_params
    params.require(:todo_item).permit(:title, :completed)
  end
end
