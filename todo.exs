defmodule TodoList do
  # Create a new empty todo list
  def new do
    []
  end

  # Add an item to the list
  def add(list, item) do
    [item | list]
  end

  # Remove an item from the list
  def remove(list, item) do
    List.delete(list, item)
  end

  # Check if list contains an item
  def contains?(list, item) do
    item in list
  end

  # Display all items
  def display(list) do
    IO.puts("Your Todo List:")
    Enum.each(list, fn item ->
      IO.puts("  - #{item}")
    end)
  end
end

# Using the module
list = TodoList.new()
list = TodoList.add(list, "Learn Elixir")
list = TodoList.add(list, "Build a project")
list = TodoList.add(list, "Deploy to production")
TodoList.display(list)