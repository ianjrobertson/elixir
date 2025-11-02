# Elixir Concepts Explained

Deep dive into the Elixir concepts you'll encounter while building the Task Tracker.

## Table of Contents

1. [Pattern Matching](#pattern-matching)
2. [Immutability](#immutability)
3. [Functions and Modules](#functions-and-modules)
4. [Data Structures](#data-structures)
5. [Pipe Operator](#pipe-operator)
6. [Error Handling](#error-handling)
7. [Recursion and Enumeration](#recursion-and-enumeration)
8. [Processes and Concurrency](#processes-and-concurrency)

---

## Pattern Matching

Pattern matching is one of Elixir's most powerful features. The `=` operator is not assignment - it's the match operator!

### Basic Pattern Matching

```elixir
# Simple matching
x = 1
1 = x  # This works! Pattern matches successfully

# This would fail:
2 = x  # MatchError!

# Matching with tuples
{:ok, value} = {:ok, 42}
# value is now 42

{:error, reason} = {:error, "Not found"}
# reason is now "Not found"
```

### Destructuring

```elixir
# Lists
[head | tail] = [1, 2, 3, 4]
# head = 1
# tail = [2, 3, 4]

[first, second | rest] = [1, 2, 3, 4, 5]
# first = 1, second = 2, rest = [3, 4, 5]

# Maps
%{name: name, age: age} = %{name: "Alice", age: 30, city: "NYC"}
# name = "Alice", age = 30
# Note: city is ignored

# Structs
%Task{id: id, description: desc} = %Task{id: 1, description: "Learn Elixir"}
# id = 1, desc = "Learn Elixir"
```

### Function Clauses

```elixir
defmodule Math do
  # Pattern match on function arguments
  def zero?(0), do: true
  def zero?(_), do: false

  # Match on data structure
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  # Match on tuples
  def handle_result({:ok, value}), do: "Success: #{value}"
  def handle_result({:error, reason}), do: "Error: #{reason}"
end
```

### Case Expressions

```elixir
case TaskList.find(list, id) do
  {:ok, task} ->
    IO.puts("Found: #{task.description}")

  {:error, reason} ->
    IO.puts("Error: #{reason}")
end
```

### The Pin Operator `^`

Use `^` when you want to match against a variable's value, not rebind it:

```elixir
x = 1

# Without pin - rebinds x to 2
x = 2  # x is now 2

# With pin - matches against current value
^x = 3  # MatchError! because x is 2, not 3
^x = 2  # Success! x matches 2
```

---

## Immutability

In Elixir, all data is immutable. You cannot change data once it's created - you create new data instead.

### Why Immutability?

1. **Thread safety** - No race conditions
2. **Easier reasoning** - Data can't change unexpectedly
3. **Reliable state** - Functions don't have side effects

### Examples

```elixir
# Lists
list = [1, 2, 3]
new_list = [0 | list]  # Creates NEW list [0, 1, 2, 3]
# list is still [1, 2, 3]

# Maps
map = %{name: "Alice"}
new_map = Map.put(map, :age, 30)  # Creates NEW map
# map is still %{name: "Alice"}
# new_map is %{name: "Alice", age: 30}

# Structs
task = %Task{id: 1, description: "Learn"}
completed = %{task | completed: true}  # Creates NEW struct
# task.completed is still false
# completed.completed is true
```

### Update Syntax

```elixir
# Map update syntax
original = %{a: 1, b: 2}
updated = %{original | a: 10}  # %{a: 10, b: 2}

# Only works for EXISTING keys!
# %{original | c: 3}  # KeyError!

# To add new keys, use Map.put
with_new = Map.put(original, :c, 3)
```

### Practical Impact

```elixir
defmodule TaskList do
  def complete(task_list, id) do
    # This returns a NEW task list
    # The original is unchanged
    update_task(task_list, id, &Task.complete/1)
  end
end

# Usage
list1 = TaskList.new()
list2 = TaskList.add(list1, "Task 1")
list3 = TaskList.complete(list2, 1)

# list1, list2, and list3 are all different!
# list1 is empty
# list2 has 1 incomplete task
# list3 has 1 completed task
```

---

## Functions and Modules

### Modules

Modules are namespaces for functions:

```elixir
defmodule Calculator do
  # Public function
  def add(a, b) do
    a + b
  end

  # Private function (only callable within module)
  defp validate(num) when is_number(num), do: :ok
  defp validate(_), do: {:error, "Not a number"}
end
```

### Functions

```elixir
# Named function (must be in a module)
def function_name(arg1, arg2) do
  # body
end

# One-line syntax
def add(a, b), do: a + b

# Anonymous function
add = fn a, b -> a + b end
add.(2, 3)  # Note the dot!

# Shorthand for anonymous functions
add = &(&1 + &2)
add.(2, 3)
```

### Function Arity

Functions are identified by name AND arity (number of arguments):

```elixir
defmodule Example do
  def greet(name), do: "Hello, #{name}"
  def greet(first, last), do: "Hello, #{first} #{last}"
end

# These are two DIFFERENT functions:
# greet/1 and greet/2
```

### Guards

Add constraints to function clauses:

```elixir
defmodule Math do
  def divide(a, b) when b != 0 do
    a / b
  end

  def divide(_, 0) do
    {:error, "Division by zero"}
  end
end

# Common guards:
# is_number(x)
# is_atom(x)
# is_list(x)
# x > 0
# x in [1, 2, 3]
```

### Default Arguments

```elixir
defmodule Greeter do
  def hello(name \\ "World") do
    "Hello, #{name}"
  end
end

Greeter.hello()        # "Hello, World"
Greeter.hello("Alice") # "Hello, Alice"
```

### Function Capturing

Reference existing functions:

```elixir
# Capture named function
complete_fn = &Task.complete/1

# Use it
completed_task = complete_fn.(task)

# Capture with partial application
add_five = &(&1 + 5)
add_five.(10)  # 15
```

---

## Data Structures

### Tuples

Fixed-size, ordered collections. Fast access by index.

```elixir
# Creation
tuple = {:ok, "Success", 123}

# Pattern matching
{:ok, message, code} = tuple

# Access by index (0-based)
elem(tuple, 0)  # :ok

# Update (creates new tuple)
put_elem(tuple, 1, "Updated")

# Common use: return values
def divide(a, b) when b != 0, do: {:ok, a / b}
def divide(_, 0), do: {:error, "Division by zero"}
```

### Lists

Dynamic size, linked lists. Fast head access.

```elixir
# Creation
list = [1, 2, 3]

# Add to front (O(1))
new_list = [0 | list]  # [0, 1, 2, 3]

# Concatenation (O(n))
[1, 2] ++ [3, 4]  # [1, 2, 3, 4]

# Subtraction
[1, 2, 3, 2] -- [2]  # [1, 3, 2]

# Pattern matching
[head | tail] = [1, 2, 3]
# head = 1, tail = [2, 3]

# Head and tail functions
hd([1, 2, 3])  # 1
tl([1, 2, 3])  # [2, 3]
```

### Maps

Key-value stores. Keys can be any type.

```elixir
# Creation
map = %{name: "Alice", age: 30}
map = %{"name" => "Alice", "age" => 30}

# Access
map[:name]  # "Alice" (atoms only)
map["name"]  # "Alice" (any key)
Map.get(map, :name)  # "Alice"

# Update
%{map | age: 31}  # Updates existing key
Map.put(map, :city, "NYC")  # Adds new key

# Delete
Map.delete(map, :age)

# Pattern matching
%{name: name} = %{name: "Alice", age: 30}
# name = "Alice"
```

### Keyword Lists

Lists of tuples with atom keys. Allows duplicate keys, ordered.

```elixir
# Creation (shorthand)
opts = [debug: true, timeout: 1000]

# Equivalent to:
opts = [{:debug, true}, {:timeout, 1000}]

# Access
opts[:debug]  # true
Keyword.get(opts, :timeout)  # 1000

# Common for function options
def request(url, opts \\ []) do
  timeout = Keyword.get(opts, :timeout, 5000)
  # ...
end

request("example.com", timeout: 3000, retry: 2)
```

### Structs

Named maps with defined fields and defaults.

```elixir
defmodule Task do
  defstruct [
    :id,
    :description,
    completed: false,
    tags: []
  ]
end

# Creation
task = %Task{id: 1, description: "Learn"}

# Access (like maps)
task.id  # 1
task.completed  # false

# Update
%{task | completed: true}

# Pattern matching
%Task{id: id, completed: status} = task

# Structs ARE maps underneath
is_map(task)  # true
task.__struct__  # Task
```

---

## Pipe Operator

The pipe `|>` operator takes the result of one expression and passes it as the first argument to the next function.

### Basic Usage

```elixir
# Without pipe
String.upcase(String.trim("  hello  "))

# With pipe - much more readable!
"  hello  "
|> String.trim()
|> String.upcase()

# Result: "HELLO"
```

### How It Works

```elixir
# These are equivalent:
value |> function()
function(value)

value |> function(arg2, arg3)
function(value, arg2, arg3)
```

### Real Examples

```elixir
# Task counting
def count_high_priority_pending(task_list) do
  task_list
  |> TaskList.filter_by_status(:pending)
  |> Enum.filter(fn t -> t.priority == :high end)
  |> length()
end

# String processing
def format_name(name) do
  name
  |> String.trim()
  |> String.downcase()
  |> String.capitalize()
end

# Data transformation
users
|> Enum.filter(&(&1.age >= 18))
|> Enum.map(&(&1.name))
|> Enum.sort()
|> Enum.take(10)
```

### When NOT to Use

```elixir
# Don't use for single operation
# Bad:
result = value |> function()

# Good:
result = function(value)

# Don't force it when it's not the first arg
# Bad:
list |> Enum.member?(item)  # Reads wrong

# Better:
Enum.member?(list, item)
```

---

## Error Handling

Elixir uses tagged tuples for error handling, not exceptions.

### Tagged Tuples

```elixir
# Success
{:ok, result}

# Error
{:error, reason}

# Functions return these
def divide(a, b) when b != 0, do: {:ok, a / b}
def divide(_, 0), do: {:error, "Division by zero"}
```

### Pattern Matching for Errors

```elixir
case divide(10, 2) do
  {:ok, result} ->
    IO.puts("Result: #{result}")

  {:error, reason} ->
    IO.puts("Error: #{reason}")
end
```

### The `with` Statement

Chain operations that might fail:

```elixir
def process_task(id) do
  with {:ok, task} <- TaskList.find(list, id),
       {:ok, validated} <- validate_task(task),
       {:ok, processed} <- process(validated) do
    {:ok, processed}
  else
    {:error, reason} -> {:error, reason}
  end
end

# If ANY step returns {:error, _}, execution jumps to else
```

### Bang Functions

Functions ending in `!` raise exceptions instead of returning errors:

```elixir
# Safe version
File.read("file.txt")
# Returns {:ok, content} or {:error, reason}

# Bang version
File.read!("file.txt")
# Returns content or raises exception

# Use bang when:
# 1. You KNOW it will succeed
# 2. You WANT it to crash if it fails
```

### try/rescue

For handling exceptions (use sparingly):

```elixir
try do
  risky_operation()
rescue
  e in RuntimeError ->
    IO.puts("Caught runtime error: #{e.message}")
end
```

### Best Practices

1. **Prefer tagged tuples** over exceptions
2. **Use exceptions for truly exceptional cases** (programming errors)
3. **Let it crash** - don't try to catch everything
4. **Use supervisors** to handle crashes at system level

---

## Recursion and Enumeration

### Recursion Basics

Elixir has no loops - use recursion instead!

```elixir
defmodule Math do
  # Count down to zero
  def countdown(0), do: IO.puts("Done!")
  def countdown(n) when n > 0 do
    IO.puts(n)
    countdown(n - 1)
  end

  # Sum a list
  def sum([]), do: 0
  def sum([head | tail]) do
    head + sum(tail)
  end

  # Length of list
  def length([]), do: 0
  def length([_ | tail]) do
    1 + length(tail)
  end
end
```

### Tail Call Optimization

Tail-recursive functions are optimized to not grow the stack:

```elixir
# Not tail-recursive (grows stack)
def sum([]), do: 0
def sum([h | t]), do: h + sum(t)  # Addition happens AFTER recursive call

# Tail-recursive (optimized)
def sum(list), do: sum(list, 0)

defp sum([], acc), do: acc
defp sum([h | t], acc), do: sum(t, acc + h)  # Recursive call is LAST thing
```

### The Enum Module

Most of the time, use `Enum` instead of writing recursion:

```elixir
# Map - transform each element
Enum.map([1, 2, 3], fn x -> x * 2 end)
# [2, 4, 6]

# Filter - keep elements matching condition
Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)
# [2, 4]

# Reduce - accumulate a value
Enum.reduce([1, 2, 3, 4], 0, fn x, acc -> x + acc end)
# 10

# Find - get first matching element
Enum.find([1, 2, 3, 4], fn x -> x > 2 end)
# 3

# Any? - check if any element matches
Enum.any?([1, 2, 3], fn x -> x > 5 end)
# false

# All? - check if all elements match
Enum.all?([2, 4, 6], fn x -> rem(x, 2) == 0 end)
# true
```

### Common Patterns

```elixir
# Count elements matching condition
pending_count =
  tasks
  |> Enum.filter(fn t -> !t.completed end)
  |> length()

# Group by property
tasks_by_priority = Enum.group_by(tasks, fn t -> t.priority end)
# %{high: [...], medium: [...], low: [...]}

# Sort
sorted = Enum.sort(tasks, fn t1, t2 -> t1.id < t2.id end)

# Take first N
first_five = Enum.take(tasks, 5)

# Chunk into groups
chunks = Enum.chunk_every(tasks, 10)  # Groups of 10
```

---

## Processes and Concurrency

Elixir runs on the BEAM VM, which gives you lightweight processes and fault tolerance.

### Processes

Processes are NOT OS processes - they're BEAM processes. You can have millions!

```elixir
# Spawn a process
pid = spawn(fn -> IO.puts("Hello from process!") end)

# Send a message
send(pid, {:hello, "World"})

# Receive a message
receive do
  {:hello, msg} -> IO.puts("Got: #{msg}")
after
  1000 -> IO.puts("Timeout!")
end
```

### GenServer

GenServer is the standard way to manage state in a process:

```elixir
defmodule Counter do
  use GenServer

  # Client API

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  # Server Callbacks

  @impl true
  def init(initial_value) do
    {:ok, initial_value}
  end

  @impl true
  def handle_call(:increment, _from, state) do
    new_state = state + 1
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end

# Usage
{:ok, pid} = Counter.start_link(0)
Counter.increment()  # 1
Counter.increment()  # 2
Counter.get()        # 2
```

### Why Use GenServer?

1. **State management** - Keep state in a process
2. **Concurrent access** - Multiple callers, safe state
3. **Message handling** - Queue messages automatically
4. **OTP integration** - Works with supervisors

### Call vs Cast

```elixir
# call - synchronous, waits for reply
def get_value do
  GenServer.call(__MODULE__, :get)
end

# cast - asynchronous, no reply
def log_event(event) do
  GenServer.cast(__MODULE__, {:log, event})
end

# In server:
def handle_call(:get, _from, state) do
  {:reply, state, state}
end

def handle_cast({:log, event}, state) do
  IO.puts("Event: #{event}")
  {:noreply, state}
end
```

### Supervisors

Supervisors monitor processes and restart them if they crash:

```elixir
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      TaskServer,  # Will be restarted if it crashes
      # ... other workers
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

---

## Summary

These concepts form the foundation of Elixir programming:

1. **Pattern matching** - The core of Elixir's power
2. **Immutability** - Safety and predictability
3. **Functions** - First-class, composable
4. **Data structures** - Rich and efficient
5. **Pipe operator** - Readable transformations
6. **Error handling** - Explicit and clear
7. **Recursion/Enum** - Process collections
8. **Processes** - Concurrency and fault tolerance

Master these, and you'll be writing idiomatic Elixir in no time!
