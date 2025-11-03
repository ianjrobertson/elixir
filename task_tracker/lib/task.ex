defmodule TodoTask do
  defstruct [
    :id,
    :description,
    completed: false,
    created_at: nil,
    priority: :medium,
    tags: []
  ]

  def new(id, description) do
    %TodoTask{
      id: id,
      description: description,
      created_at: DateTime.utc_now()
    }
  end

  def complete(task) do
    %{task | completed: true}
  end

  def uncomplete(task) do
    %{task | completed: false}
  end

  def set_priority(task, priority) when priority in [:low, :medium, :high] do
    {:ok, %{task | priority: priority}}
  end

  def set_priority(_task, _priority) do
    {:error, "Priority must be :low, :medium, or :high"}
  end

  def add_tag(task, tag) do
    %{task | tags: [tag | task.tags]}
  end
end
