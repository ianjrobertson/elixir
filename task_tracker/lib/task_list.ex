defmodule TaskList do
  @moduledoc """
  Manages a collection of tasks.
  """

  @doc """
  Creates a new empty task list.
  """
  def new do
    %{tasks: [], next_id: 1}
  end

  @doc """
  Adds a task to the list.

  ## Examples

      iex> list = TaskList.new()
      iex> list = TaskList.add(list, "Learn Elixir")
      iex> length(list.tasks)
      1
  """
  def add(task_list, description) do
    new_task = TodoTask.new(task_list.next_id, description)

    %{
      tasks: [new_task | task_list.tasks],
      next_id: task_list.next_id + 1
    }
  end

  @doc """
  Lists all tasks.
  """
  def all(task_list) do
    # Reverse to show oldest first
    Enum.reverse(task_list.tasks)
  end

  @doc """
  Finds a task by ID.
  Returns {:ok, task} if found, {:error, reason} if not.
  """
  def find(task_list, id) do
    case Enum.find(task_list.tasks, fn task -> task.id == id end) do
      nil -> {:error, "Task not found"}
      task -> {:ok, task}
    end
  end

  @doc """
  Completes a task by ID.
  """
  def complete(task_list, id) do
    update_task(task_list, id, &TodoTask.complete/1)
  end

  @doc """
  Deletes a task by ID.
  """
  def delete(task_list, id) do
    tasks = Enum.reject(task_list.tasks, fn task -> task.id == id end)
    %{task_list | tasks: tasks}
  end

  @doc """
  Filters tasks by completion status.
  """
  def filter_by_status(task_list, :completed) do
    Enum.filter(task_list.tasks, fn task -> task.completed end)
  end

  def filter_by_status(task_list, :pending) do
    Enum.filter(task_list.tasks, fn task -> !task.completed end)
  end

  @doc """
  Counts total tasks.
  """
  def count(task_list) do
    length(task_list.tasks)
  end

  @doc """
  Counts completed tasks.
  """
  def count_completed(task_list) do
    task_list
    |> filter_by_status(:completed)
    |> length()
  end

  # Private helper function
  defp update_task(task_list, id, update_fn) do
    tasks = Enum.map(task_list.tasks, fn task ->
      if task.id == id do
        update_fn.(task)
      else
        task
      end
    end)

    %{task_list | tasks: tasks}
  end
end
