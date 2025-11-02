# Practice Exercises

Hands-on exercises to reinforce your Elixir learning. Complete these in order as you progress through the project phases.

## Phase 1 Exercises: Fundamentals

### Exercise 1: Pattern Matching Practice

Create a file `exercises/pattern_matching.exs` and solve these:

```elixir
defmodule PatternPractice do
  # 1. Extract values from this tuple
  # Expected: first = 1, second = 2, rest = [3, 4, 5]
  def extract_tuple do
    data = {1, 2, [3, 4, 5]}
    # Your code here
  end

  # 2. Match only tasks with high priority
  def match_high_priority(task) do
    # Return true if priority is :high, false otherwise
    # Use pattern matching, not if/else!
  end

  # 3. Destructure a task to get id and description
  def get_task_info(task) do
    # Return {id, description}
  end

  # 4. Match nested data
  def get_first_tag(task) do
    # Return the first tag if tags exist, :no_tags otherwise
    # Use pattern matching!
  end
end
```

**Solutions:** <details><summary>Click to reveal</summary>

```elixir
defmodule PatternPractice do
  def extract_tuple do
    {first, second, rest} = {1, 2, [3, 4, 5]}
    {first, second, rest}
  end

  def match_high_priority(%{priority: :high}), do: true
  def match_high_priority(_), do: false

  def get_task_info(%Task{id: id, description: description}) do
    {id, description}
  end

  def get_first_tag(%Task{tags: [first | _]}), do: first
  def get_first_tag(_), do: :no_tags
end
```
</details>

### Exercise 2: List Manipulation

```elixir
defmodule ListPractice do
  # 1. Implement your own map function using recursion
  def my_map([], _fun), do: []
  def my_map([head | tail], fun) do
    # Your code here
  end

  # 2. Implement filter using recursion
  def my_filter([], _fun), do: []
  def my_filter([head | tail], fun) do
    # Your code here
  end

  # 3. Find the maximum value in a list
  def max([single]), do: # Your code
  def max([head | tail]) do
    # Your code here
  end

  # 4. Reverse a list (don't use Enum.reverse!)
  def reverse(list) do
    # Hint: use an accumulator
  end
end
```

**Solutions:** <details><summary>Click to reveal</summary>

```elixir
defmodule ListPractice do
  def my_map([], _fun), do: []
  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_filter([], _fun), do: []
  def my_filter([head | tail], fun) do
    if fun.(head) do
      [head | my_filter(tail, fun)]
    else
      my_filter(tail, fun)
    end
  end

  def max([single]), do: single
  def max([head | tail]) do
    tail_max = max(tail)
    if head > tail_max, do: head, else: tail_max
  end

  def reverse(list), do: reverse(list, [])

  defp reverse([], acc), do: acc
  defp reverse([head | tail], acc) do
    reverse(tail, [head | acc])
  end
end
```
</details>

### Exercise 3: Extend the Task Module

Add these functions to your `Task` module:

```elixir
defmodule Task do
  # ... existing code ...

  # 1. Check if a task is overdue
  # Return true if task has a due_date in the past and is not completed
  def overdue?(task) do
    # Your code here
  end

  # 2. Get a human-readable status
  # Return "Completed", "Pending", or "Overdue"
  def status(task) do
    # Use pattern matching and guards
  end

  # 3. Toggle completion status
  def toggle(task) do
    # Your code here
  end

  # 4. Remove a specific tag
  def remove_tag(task, tag_to_remove) do
    # Your code here
  end
end
```

**Write tests for each function!**

### Exercise 4: Task Queries

Create a new module for querying tasks:

```elixir
defmodule TaskQueries do
  # 1. Find all tasks containing a keyword in description
  def search(tasks, keyword) do
    # Use Enum.filter and String.contains?
  end

  # 2. Get tasks due within N days
  def due_soon(tasks, days) do
    # Your code here
  end

  # 3. Group tasks by completion status
  def group_by_status(tasks) do
    # Return %{completed: [...], pending: [...]}
  end

  # 4. Calculate completion percentage
  def completion_rate(tasks) do
    # Return percentage as float (0.0 - 100.0)
  end
end
```

---

## Phase 2 Exercises: Intermediate

### Exercise 5: Error Handling

Practice proper error handling:

```elixir
defmodule SafeTaskList do
  # 1. Safe task lookup that returns {:ok, task} or {:error, reason}
  def find_task(task_list, id) do
    # Your code here
  end

  # 2. Validate task data before creating
  # Check that description is not empty, priority is valid, etc.
  def validate_and_create(id, description, opts \\ []) do
    # Return {:ok, task} or {:error, reason}
  end

  # 3. Chain operations with `with`
  # Complete a task only if it exists and is not already completed
  def safe_complete(task_list, id) do
    with {:ok, task} <- find_task(task_list, id),
         false <- task.completed do
      {:ok, TaskList.complete(task_list, id)}
    else
      true -> {:error, "Task already completed"}
      error -> error
    end
  end
end
```

### Exercise 6: File Operations

Extend the storage module:

```elixir
defmodule Storage do
  # ... existing code ...

  # 1. Export tasks to CSV
  def export_csv(task_list, filename) do
    # Format: id,description,completed,priority
  end

  # 2. Import from CSV
  def import_csv(filename) do
    # Return {:ok, task_list} or {:error, reason}
  end

  # 3. Create a backup
  def backup(filename \\ "tasks.json") do
    # Save to "tasks_backup_TIMESTAMP.json"
  end

  # 4. List all backups
  def list_backups do
    # Return list of backup filenames
  end
end
```

### Exercise 7: Advanced Filtering

Add sophisticated filtering to TaskList:

```elixir
defmodule TaskList do
  # ... existing code ...

  # 1. Filter by multiple criteria
  def filter(task_list, opts \\ []) do
    # opts can include:
    # - status: :completed | :pending
    # - priority: :high | :medium | :low
    # - tag: string
    # - search: string (searches description)
    #
    # Example: filter(list, status: :pending, priority: :high)
  end

  # 2. Sort tasks
  def sort_by(task_list, field) do
    # field can be: :id, :created_at, :priority, :description
  end

  # 3. Get statistics
  def stats(task_list) do
    # Return a map with:
    # %{
    #   total: count,
    #   completed: count,
    #   pending: count,
    #   by_priority: %{high: count, medium: count, low: count}
    # }
  end
end
```

### Exercise 8: CLI Improvements

Enhance the CLI with these features:

```elixir
defmodule TaskTracker.CLI do
  # 1. Add priority when creating tasks
  # Usage: task_tracker add "Task description" --priority high

  # 2. Add tags when creating tasks
  # Usage: task_tracker add "Task description" --tags work,urgent

  # 3. Search tasks
  # Usage: task_tracker search "keyword"

  # 4. Show task statistics
  # Usage: task_tracker stats

  # 5. Better formatting with colors (optional: use IO.ANSI)
  # - Green for completed tasks
  # - Red for overdue tasks
  # - Yellow for high priority
end
```

---

## Phase 3 Exercises: Advanced

### Exercise 9: GenServer Practice

Create a counter GenServer from scratch:

```elixir
defmodule Counter do
  use GenServer

  # Implement these client functions:
  # - start_link(initial_value)
  # - increment()
  # - decrement()
  # - get()
  # - reset()
  # - add(amount)

  # Implement the server callbacks
end
```

Then write tests:

```elixir
defmodule CounterTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Counter.start_link(0)
    %{counter: pid}
  end

  test "increments counter" do
    # Your test
  end

  # More tests...
end
```

### Exercise 10: Task Dependencies

Implement task dependencies:

```elixir
defmodule Task do
  defstruct [
    :id,
    :description,
    completed: false,
    depends_on: []  # List of task IDs
  ]

  def add_dependency(task, dependency_id) do
    # Your code
  end
end

defmodule TaskList do
  # Check if task can be completed (all dependencies are done)
  def can_complete?(task_list, id) do
    # Your code
  end

  # Get all tasks that are blocked by a given task
  def blocked_by(task_list, id) do
    # Your code
  end

  # Get tasks in dependency order (topological sort)
  def dependency_order(task_list) do
    # Your code - this is challenging!
  end
end
```

### Exercise 11: Undo/Redo

Implement undo/redo functionality:

```elixir
defmodule TaskHistory do
  defstruct [
    current: nil,
    past: [],
    future: []
  ]

  def new(initial_state) do
    # Your code
  end

  def push(history, new_state) do
    # Add new state, clear future
  end

  def undo(history) do
    # Move current to future, pop from past
    # Return {:ok, new_history} or {:error, "Nothing to undo"}
  end

  def redo(history) do
    # Move current to past, pop from future
    # Return {:ok, new_history} or {:error, "Nothing to redo"}
  end

  def current(history) do
    # Return current state
  end
end

# Integrate with GenServer
defmodule TaskServer do
  # Modify to use TaskHistory
  # Add undo/redo commands
end
```

### Exercise 12: Testing

Write comprehensive tests:

```elixir
defmodule TaskTest do
  use ExUnit.Case
  doctest Task

  describe "new/2" do
    # Test all aspects of task creation
  end

  describe "dependencies" do
    # Test dependency management
  end
end

defmodule TaskListTest do
  use ExUnit.Case

  describe "filtering" do
    # Test complex filters
  end

  describe "statistics" do
    # Test stats calculation
  end
end

defmodule TaskServerTest do
  use ExUnit.Case

  # Test concurrent access
  test "handles concurrent updates" do
    # Start server
    # Spawn multiple processes
    # Each process modifies tasks
    # Verify consistency
  end
end
```

---

## Challenge Exercises

### Challenge 1: Recurring Tasks

Implement recurring tasks:

```elixir
defmodule RecurringTask do
  defstruct [
    :id,
    :description,
    :recurrence,  # :daily, :weekly, :monthly
    :last_completed,
    :next_due
  ]

  # Implement:
  # - Creating recurring tasks
  # - Checking if task is due
  # - Completing (which creates next instance)
  # - Skipping an instance
end
```

### Challenge 2: Task Projects

Group tasks into projects:

```elixir
defmodule Project do
  defstruct [
    :id,
    :name,
    :description,
    task_ids: []
  ]
end

defmodule ProjectManager do
  # Manage projects and their tasks
  # Calculate project completion percentage
  # Get project statistics
  # Archive completed projects
end
```

### Challenge 3: Task Notifications

Implement a notification system:

```elixir
defmodule NotificationServer do
  use GenServer

  # Check for tasks due soon
  # Send notifications (print to console)
  # Run checks periodically (use Process.send_after)
  # Allow subscribing to notifications
end
```

### Challenge 4: Web Interface

Build a simple web interface with Phoenix:

1. Create a Phoenix project
2. Build API endpoints for task operations
3. Create a simple frontend (LiveView or HTML)
4. Add real-time updates

---

## Learning Tips

1. **Do exercises in order** - They build on each other
2. **Write tests first** - Practice TDD
3. **Experiment in IEx** - Try things interactively
4. **Read error messages** - They're very helpful in Elixir
5. **Don't skip exercises** - Each teaches important concepts
6. **Share your solutions** - Discuss with others
7. **Refactor** - Come back and improve your code

## Getting Help

- Read the [official Elixir docs](https://hexdocs.pm/elixir/)
- Use `h Module.function` in IEx
- Check [Elixir Forum](https://elixirforum.com/)
- Try [Exercism](https://exercism.org/tracks/elixir)

Happy coding!
