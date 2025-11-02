# Task Tracker Learning Guide

A step-by-step guide to building the Task Tracker application while learning Elixir fundamentals.

## Table of Contents

- [Phase 1: Fundamentals](#phase-1-fundamentals)
- [Phase 2: Intermediate Features](#phase-2-intermediate-features)
- [Phase 3: Advanced Features](#phase-3-advanced-features)

---

## Phase 1: Fundamentals

### Step 1: Project Setup

Create a new Mix project:

```bash
mix new task_tracker
cd task_tracker
```

**What just happened?**
- `mix` is Elixir's build tool (like npm, cargo, or maven)
- It created a standard project structure
- `mix.exs` is the project configuration file
- `lib/` contains your source code
- `test/` contains your tests

### Step 2: Understanding the Task Struct

**Concept: Structs**
Structs are named maps with a defined set of fields. They're perfect for modeling data.

Create `lib/task.ex`:

```elixir
defmodule Task do
  @moduledoc """
  Represents a single task with its properties.
  """

  # Define the struct with default values
  defstruct [
    :id,
    :description,
    completed: false,
    created_at: nil,
    priority: :medium,
    tags: []
  ]

  @doc """
  Creates a new task with a description.

  ## Examples

      iex> Task.new(1, "Learn Elixir")
      %Task{id: 1, description: "Learn Elixir", completed: false}
  """
  def new(id, description) do
    %Task{
      id: id,
      description: description,
      created_at: DateTime.utc_now()
    }
  end

  @doc """
  Marks a task as completed.

  ## Examples

      iex> task = Task.new(1, "Learn Elixir")
      iex> Task.complete(task)
      %Task{id: 1, description: "Learn Elixir", completed: true}
  """
  def complete(task) do
    %{task | completed: true}
  end

  @doc """
  Marks a task as incomplete.
  """
  def uncomplete(task) do
    %{task | completed: false}
  end

  @doc """
  Sets the priority of a task.
  Priority must be :low, :medium, or :high.
  """
  def set_priority(task, priority) when priority in [:low, :medium, :high] do
    {:ok, %{task | priority: priority}}
  end

  def set_priority(_task, _priority) do
    {:error, "Priority must be :low, :medium, or :high"}
  end

  @doc """
  Adds a tag to a task.
  """
  def add_tag(task, tag) do
    %{task | tags: [tag | task.tags]}
  end
end
```

**Key Concepts Introduced:**
1. **defmodule** - Defines a module (namespace for functions)
2. **defstruct** - Defines a struct with fields
3. **@moduledoc** and **@doc** - Documentation attributes
4. **def** - Defines a public function
5. **%Task{}** - Creates a struct instance
6. **%{task | field: value}** - Updates a struct (returns new struct, original unchanged)
7. **Guard clauses** - `when priority in [:low, :medium, :high]`
8. **Atoms** - `:low, :medium, :high` - constants/symbols
9. **Tuples** - `{:ok, value}` or `{:error, reason}` for error handling

**Try it in IEx:**

```bash
iex -S mix
```

```elixir
# Create a new task
task = Task.new(1, "Learn pattern matching")

# Complete it
completed_task = Task.complete(task)

# Notice the original task is unchanged! (immutability)
IO.inspect(task)
IO.inspect(completed_task)
```

### Step 3: Task List Management

Create `lib/task_list.ex`:

```elixir
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
    new_task = Task.new(task_list.next_id, description)

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
    update_task(task_list, id, &Task.complete/1)
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
```

**Key Concepts Introduced:**
1. **Maps** - `%{key: value}` - key-value data structure
2. **Enum module** - Functions for working with collections
3. **Anonymous functions** - `fn task -> task.id == id end`
4. **Pipe operator** - `|>` - chains function calls
5. **Pattern matching** - `case` statement
6. **defp** - Defines a private function
7. **Capture operator** - `&Task.complete/1` - reference to function

**Try it in IEx:**

```elixir
# Create a task list
list = TaskList.new()

# Add some tasks
list = TaskList.add(list, "Learn pattern matching")
list = TaskList.add(list, "Build a CLI app")
list = TaskList.add(list, "Master Elixir")

# List all tasks
TaskList.all(list)

# Complete task 1
list = TaskList.complete(list, 1)

# Show only pending tasks
TaskList.filter_by_status(list, :pending)

# Count completed tasks
TaskList.count_completed(list)
```

### Step 4: Writing Tests

Create `test/task_test.exs`:

```elixir
defmodule TaskTest do
  use ExUnit.Case
  doctest Task

  describe "new/2" do
    test "creates a task with id and description" do
      task = Task.new(1, "Test task")

      assert task.id == 1
      assert task.description == "Test task"
      assert task.completed == false
      assert task.priority == :medium
    end

    test "sets created_at timestamp" do
      task = Task.new(1, "Test task")

      assert task.created_at != nil
    end
  end

  describe "complete/1" do
    test "marks task as completed" do
      task = Task.new(1, "Test task")
      completed = Task.complete(task)

      assert completed.completed == true
    end

    test "does not modify original task (immutability)" do
      task = Task.new(1, "Test task")
      _completed = Task.complete(task)

      assert task.completed == false
    end
  end

  describe "set_priority/2" do
    test "sets valid priority" do
      task = Task.new(1, "Test task")

      {:ok, updated} = Task.set_priority(task, :high)
      assert updated.priority == :high
    end

    test "rejects invalid priority" do
      task = Task.new(1, "Test task")

      result = Task.set_priority(task, :urgent)
      assert result == {:error, "Priority must be :low, :medium, or :high"}
    end
  end
end
```

Create `test/task_list_test.exs`:

```elixir
defmodule TaskListTest do
  use ExUnit.Case

  describe "new/0" do
    test "creates empty task list" do
      list = TaskList.new()

      assert list.tasks == []
      assert list.next_id == 1
    end
  end

  describe "add/2" do
    test "adds a task to the list" do
      list = TaskList.new()
      list = TaskList.add(list, "Test task")

      assert TaskList.count(list) == 1
      assert hd(list.tasks).description == "Test task"
    end

    test "increments next_id" do
      list = TaskList.new()
      list = TaskList.add(list, "Task 1")
      list = TaskList.add(list, "Task 2")

      assert list.next_id == 3
    end
  end

  describe "complete/2" do
    test "marks task as completed" do
      list = TaskList.new()
      list = TaskList.add(list, "Test task")
      list = TaskList.complete(list, 1)

      {:ok, task} = TaskList.find(list, 1)
      assert task.completed == true
    end
  end

  describe "filter_by_status/2" do
    test "filters completed tasks" do
      list = TaskList.new()
      list = TaskList.add(list, "Task 1")
      list = TaskList.add(list, "Task 2")
      list = TaskList.complete(list, 1)

      completed = TaskList.filter_by_status(list, :completed)
      assert length(completed) == 1
    end

    test "filters pending tasks" do
      list = TaskList.new()
      list = TaskList.add(list, "Task 1")
      list = TaskList.add(list, "Task 2")
      list = TaskList.complete(list, 1)

      pending = TaskList.filter_by_status(list, :pending)
      assert length(pending) == 1
    end
  end
end
```

**Run the tests:**

```bash
mix test
```

**Key Concepts Introduced:**
1. **ExUnit** - Elixir's testing framework
2. **use ExUnit.Case** - Imports testing macros
3. **describe/2** - Groups related tests
4. **test/2** - Defines a test
5. **assert** - Test assertion
6. **doctest** - Tests code examples in documentation

---

## Phase 2: Intermediate Features

### Step 5: File Storage

Create `lib/storage.ex`:

```elixir
defmodule Storage do
  @moduledoc """
  Handles saving and loading task lists to/from disk.
  """

  @default_file "tasks.json"

  @doc """
  Saves a task list to a file.
  """
  def save(task_list, filename \\ @default_file) do
    case encode(task_list) do
      {:ok, json} ->
        File.write(filename, json)

      {:error, reason} ->
        {:error, "Failed to encode tasks: #{reason}"}
    end
  end

  @doc """
  Loads a task list from a file.
  """
  def load(filename \\ @default_file) do
    case File.read(filename) do
      {:ok, content} ->
        decode(content)

      {:error, :enoent} ->
        {:ok, TaskList.new()}

      {:error, reason} ->
        {:error, "Failed to read file: #{reason}"}
    end
  end

  # Encode task list to JSON
  defp encode(task_list) do
    tasks_as_maps = Enum.map(task_list.tasks, &task_to_map/1)

    data = %{
      tasks: tasks_as_maps,
      next_id: task_list.next_id
    }

    Jason.encode(data)
  end

  # Decode JSON to task list
  defp decode(json) do
    case Jason.decode(json) do
      {:ok, data} ->
        tasks = Enum.map(data["tasks"], &map_to_task/1)
        {:ok, %{tasks: tasks, next_id: data["next_id"]}}

      {:error, reason} ->
        {:error, "Failed to decode JSON: #{inspect(reason)}"}
    end
  end

  # Convert task struct to map
  defp task_to_map(task) do
    %{
      "id" => task.id,
      "description" => task.description,
      "completed" => task.completed,
      "created_at" => DateTime.to_iso8601(task.created_at),
      "priority" => Atom.to_string(task.priority),
      "tags" => task.tags
    }
  end

  # Convert map to task struct
  defp map_to_task(map) do
    {:ok, created_at, _} = DateTime.from_iso8601(map["created_at"])

    %Task{
      id: map["id"],
      description: map["description"],
      completed: map["completed"],
      created_at: created_at,
      priority: String.to_atom(map["priority"]),
      tags: map["tags"]
    }
  end
end
```

**Add Jason dependency to `mix.exs`:**

```elixir
defp deps do
  [
    {:jason, "~> 1.4"}
  ]
end
```

**Install dependencies:**

```bash
mix deps.get
```

**Key Concepts Introduced:**
1. **File I/O** - `File.read/1`, `File.write/2`
2. **Error handling** - Pattern matching on `{:ok, value}` / `{:error, reason}`
3. **with statement** - Chaining operations that might fail
4. **String interpolation** - `"#{variable}"`
5. **External dependencies** - Using hex packages

### Step 6: Building the CLI

Create `lib/cli.ex`:

```elixir
defmodule TaskTracker.CLI do
  @moduledoc """
  Command-line interface for the Task Tracker application.
  """

  def main(args \\ []) do
    {task_list, _} = load_or_create()

    case parse_args(args) do
      {:add, description} ->
        add_task(task_list, description)

      {:list, filter} ->
        list_tasks(task_list, filter)

      {:complete, id} ->
        complete_task(task_list, id)

      {:delete, id} ->
        delete_task(task_list, id)

      {:help} ->
        print_help()

      {:error, message} ->
        IO.puts("Error: #{message}")
        print_help()
    end
  end

  # Parse command-line arguments
  defp parse_args([]) do
    {:list, :all}
  end

  defp parse_args(["add" | rest]) do
    description = Enum.join(rest, " ")

    if description == "" do
      {:error, "Task description cannot be empty"}
    else
      {:add, description}
    end
  end

  defp parse_args(["list"]) do
    {:list, :all}
  end

  defp parse_args(["list", "completed"]) do
    {:list, :completed}
  end

  defp parse_args(["list", "pending"]) do
    {:list, :pending}
  end

  defp parse_args(["complete", id_str]) do
    case Integer.parse(id_str) do
      {id, ""} -> {:complete, id}
      _ -> {:error, "Invalid task ID"}
    end
  end

  defp parse_args(["delete", id_str]) do
    case Integer.parse(id_str) do
      {id, ""} -> {:delete, id}
      _ -> {:error, "Invalid task ID"}
    end
  end

  defp parse_args(["help"]) do
    {:help}
  end

  defp parse_args(_) do
    {:error, "Unknown command"}
  end

  # Add a new task
  defp add_task(task_list, description) do
    updated_list = TaskList.add(task_list, description)
    Storage.save(updated_list)

    IO.puts("✓ Task added: #{description}")
  end

  # List tasks
  defp list_tasks(task_list, filter) do
    tasks = case filter do
      :all -> TaskList.all(task_list)
      :completed -> TaskList.filter_by_status(task_list, :completed)
      :pending -> TaskList.filter_by_status(task_list, :pending)
    end

    if Enum.empty?(tasks) do
      IO.puts("No tasks found.")
    else
      IO.puts("\nTasks:")
      IO.puts(String.duplicate("-", 60))

      Enum.each(tasks, &print_task/1)

      IO.puts(String.duplicate("-", 60))
      IO.puts("Total: #{length(tasks)} tasks")
    end
  end

  # Print a single task
  defp print_task(task) do
    status = if task.completed, do: "[✓]", else: "[ ]"
    priority_icon = priority_icon(task.priority)

    IO.puts("#{status} #{priority_icon} #{task.id}. #{task.description}")
  end

  # Get priority icon
  defp priority_icon(:high), do: "⚠️ "
  defp priority_icon(:medium), do: "  "
  defp priority_icon(:low), do: "  "

  # Complete a task
  defp complete_task(task_list, id) do
    updated_list = TaskList.complete(task_list, id)
    Storage.save(updated_list)

    IO.puts("✓ Task #{id} completed!")
  end

  # Delete a task
  defp delete_task(task_list, id) do
    updated_list = TaskList.delete(task_list, id)
    Storage.save(updated_list)

    IO.puts("✓ Task #{id} deleted!")
  end

  # Load task list from storage or create new one
  defp load_or_create do
    case Storage.load() do
      {:ok, task_list} -> {task_list, :loaded}
      {:error, _} -> {TaskList.new(), :created}
    end
  end

  # Print help message
  defp print_help do
    IO.puts("""
    Task Tracker - Manage your tasks from the command line

    Usage:
      task_tracker add <description>    Add a new task
      task_tracker list [filter]        List tasks (all/completed/pending)
      task_tracker complete <id>        Mark task as completed
      task_tracker delete <id>          Delete a task
      task_tracker help                 Show this help message

    Examples:
      task_tracker add Learn Elixir pattern matching
      task_tracker list
      task_tracker list pending
      task_tracker complete 1
      task_tracker delete 2
    """)
  end
end
```

**Update `mix.exs` to create an executable:**

```elixir
def project do
  [
    app: :task_tracker,
    version: "0.1.0",
    elixir: "~> 1.14",
    start_permanent: Mix.env() == :prod,
    deps: deps(),
    escript: escript()  # Add this line
  ]
end

# Add this function
defp escript do
  [main_module: TaskTracker.CLI]
end
```

**Build and run:**

```bash
mix escript.build
./task_tracker add "Learn Elixir"
./task_tracker list
./task_tracker complete 1
```

**Key Concepts Introduced:**
1. **Pattern matching in function heads** - Multiple function clauses
2. **IO module** - Console input/output
3. **String module** - String manipulation
4. **escript** - Creating executable command-line tools

---

## Phase 3: Advanced Features

### Step 7: Adding State Management with GenServer

Create `lib/task_server.ex`:

```elixir
defmodule TaskServer do
  use GenServer

  @moduledoc """
  GenServer that manages task list state in memory.
  Provides concurrent access and automatic persistence.
  """

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def add_task(description) do
    GenServer.call(__MODULE__, {:add_task, description})
  end

  def get_all_tasks do
    GenServer.call(__MODULE__, :get_all_tasks)
  end

  def complete_task(id) do
    GenServer.call(__MODULE__, {:complete_task, id})
  end

  def delete_task(id) do
    GenServer.call(__MODULE__, {:delete_task, id})
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    case Storage.load() do
      {:ok, task_list} ->
        {:ok, task_list}
      {:error, _} ->
        {:ok, TaskList.new()}
    end
  end

  @impl true
  def handle_call({:add_task, description}, _from, task_list) do
    updated_list = TaskList.add(task_list, description)
    Storage.save(updated_list)

    {:reply, :ok, updated_list}
  end

  @impl true
  def handle_call(:get_all_tasks, _from, task_list) do
    tasks = TaskList.all(task_list)
    {:reply, tasks, task_list}
  end

  @impl true
  def handle_call({:complete_task, id}, _from, task_list) do
    updated_list = TaskList.complete(task_list, id)
    Storage.save(updated_list)

    {:reply, :ok, updated_list}
  end

  @impl true
  def handle_call({:delete_task, id}, _from, task_list) do
    updated_list = TaskList.delete(task_list, id)
    Storage.save(updated_list)

    {:reply, :ok, updated_list}
  end
end
```

**Key Concepts Introduced:**
1. **GenServer** - OTP behavior for managing state
2. **Process** - Concurrent execution unit
3. **Client/Server API** - Separation of interface and implementation
4. **Callbacks** - `init/1`, `handle_call/3`
5. **@impl** - Marks callback implementations

---

## Next Steps

Congratulations! You've built a functional task tracker and learned core Elixir concepts.

**Continue Learning:**
1. Add more features (see EXERCISES.md)
2. Improve error handling
3. Add a web interface with Phoenix
4. Learn about Supervisors and fault tolerance
5. Explore advanced pattern matching

**Resources:**
- Read CONCEPTS.md for deeper explanations
- Try exercises in EXERCISES.md
- Check REFERENCE.md for quick lookups
