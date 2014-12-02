class TodoItem < ActiveRecord::Base
  validates :title, presence: true
end
