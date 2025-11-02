# Elixir Quick Reference

A cheat sheet for common Elixir patterns and syntax.

## Basic Syntax

### Variables and Data Types

```elixir
# Variables (snake_case)
name = "Alice"
age = 30
is_active = true

# Atoms (constants/symbols)
:ok
:error
:high_priority

# Numbers
42          # integer
3.14        # float
1_000_000   # underscores for readability

# Strings
"Hello, world!"
"Hello, #{name}"  # interpolation
"""
Multi-line
string
"""

# Booleans
true
false
nil  # also considered falsy
```

### Collections

```elixir
# Lists
[1, 2, 3]
[head | tail] = [1, 2, 3]

# Tuples
{:ok, "Success"}
{:error, reason}

# Maps
%{name: "Alice", age: 30}
%{"key" => "value"}

# Keyword Lists
[name: "Alice", age: 30]
```

## Pattern Matching

```elixir
# Basic matching
x = 1
{a, b} = {1, 2}
[h | t] = [1, 2, 3]

# In function heads
def greet("Alice"), do: "Hi Alice!"
def greet(name), do: "Hello, #{name}"

# In case
case result do
  {:ok, value} -> value
  {:error, _} -> nil
end

# Pin operator (match value, don't rebind)
x = 1
^x = 1  # ok
^x = 2  # MatchError
```

## Functions

```elixir
# Named function
def add(a, b) do
  a + b
end

# One-liner
def add(a, b), do: a + b

# Private function
defp helper(x), do: x * 2

# Anonymous function
add = fn a, b -> a + b end
add.(2, 3)  # 5

# Shorthand
add = &(&1 + &2)

# Function capture
double = &(&1 * 2)
complete = &Task.complete/1

# Default arguments
def greet(name \\ "World"), do: "Hello, #{name}"

# Guards
def divide(a, b) when b != 0, do: a / b
def divide(_, 0), do: {:error, "Division by zero"}
```

## Modules

```elixir
defmodule MyModule do
  @moduledoc """
  Module documentation
  """

  @default_value 10  # module attribute

  @doc """
  Function documentation
  """
  def my_function(arg) do
    # implementation
  end

  defp private_function, do: :secret
end
```

## Structs

```elixir
# Definition
defmodule User do
  defstruct [:name, :email, age: 0, active: true]
end

# Creation
user = %User{name: "Alice", email: "alice@example.com"}

# Access
user.name

# Update
%{user | age: 31}

# Pattern matching
%User{name: name, age: age} = user
```

## Control Flow

```elixir
# if/else
if condition do
  # true branch
else
  # false branch
end

# unless
unless condition do
  # false branch
end

# cond (multiple conditions)
cond do
  x < 0 -> "negative"
  x > 0 -> "positive"
  true -> "zero"  # default case
end

# case
case value do
  1 -> "one"
  2 -> "two"
  _ -> "other"
end

# with (chain operations)
with {:ok, file} <- File.read(path),
     {:ok, data} <- parse(file) do
  {:ok, data}
else
  {:error, reason} -> {:error, reason}
end
```

## Enum Functions

```elixir
# Map
Enum.map([1, 2, 3], fn x -> x * 2 end)
Enum.map([1, 2, 3], &(&1 * 2))

# Filter
Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)

# Reduce
Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)

# Find
Enum.find([1, 2, 3], fn x -> x > 2 end)

# Any?
Enum.any?([1, 2, 3], fn x -> x > 2 end)

# All?
Enum.all?([2, 4, 6], fn x -> rem(x, 2) == 0 end)

# Count
Enum.count([1, 2, 3])

# Sort
Enum.sort([3, 1, 2])
Enum.sort_by(users, &(&1.age))

# Group by
Enum.group_by(tasks, &(&1.priority))

# Take
Enum.take([1, 2, 3, 4, 5], 3)

# Drop
Enum.drop([1, 2, 3, 4, 5], 2)

# Chunk
Enum.chunk_every([1, 2, 3, 4, 5], 2)
```

## Pipe Operator

```elixir
# Without pipe
result = String.upcase(String.trim(name))

# With pipe
result =
  name
  |> String.trim()
  |> String.upcase()

# Complex pipeline
users
|> Enum.filter(&(&1.active))
|> Enum.map(&(&1.email))
|> Enum.sort()
|> Enum.take(10)
```

## String Functions

```elixir
# Length
String.length("hello")

# Concatenation
"hello" <> " " <> "world"

# Interpolation
"Hello, #{name}!"

# Case
String.upcase("hello")
String.downcase("HELLO")
String.capitalize("hello")

# Trim
String.trim("  hello  ")

# Split
String.split("a,b,c", ",")

# Replace
String.replace("hello", "l", "r")

# Contains?
String.contains?("hello", "ll")

# Starts with / Ends with
String.starts_with?("hello", "he")
String.ends_with?("hello", "lo")
```

## Map Functions

```elixir
# Get
Map.get(map, :key)
Map.get(map, :key, "default")
map[:key]

# Put
Map.put(map, :key, value)

# Update
%{map | key: new_value}

# Delete
Map.delete(map, :key)

# Keys / Values
Map.keys(map)
Map.values(map)

# Merge
Map.merge(map1, map2)

# Has key?
Map.has_key?(map, :key)
```

## List Functions

```elixir
# Head / Tail
hd([1, 2, 3])  # 1
tl([1, 2, 3])  # [2, 3]

# Prepend
[0 | list]

# Concat
[1, 2] ++ [3, 4]

# Subtract
[1, 2, 3, 2] -- [2]

# Reverse
Enum.reverse([1, 2, 3])

# Length
length([1, 2, 3])
```

## Error Handling

```elixir
# Tagged tuples
{:ok, result}
{:error, reason}

# Case matching
case operation() do
  {:ok, result} -> result
  {:error, reason} -> handle_error(reason)
end

# With
with {:ok, a} <- step1(),
     {:ok, b} <- step2(a) do
  {:ok, b}
else
  {:error, reason} -> {:error, reason}
end

# Try/rescue (rare)
try do
  risky_operation()
rescue
  e in RuntimeError -> handle_error(e)
end

# Bang functions (raise on error)
File.read!("file.txt")
```

## Processes & GenServer

```elixir
# Spawn
pid = spawn(fn -> do_work() end)

# Send message
send(pid, {:hello, "world"})

# Receive
receive do
  {:hello, msg} -> IO.puts(msg)
after
  1000 -> IO.puts("Timeout")
end

# GenServer boilerplate
defmodule MyServer do
  use GenServer

  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def update(value) do
    GenServer.cast(__MODULE__, {:update, value})
  end

  # Server Callbacks
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:update, value}, _state) do
    {:noreply, value}
  end
end
```

## Testing

```elixir
defmodule MyModuleTest do
  use ExUnit.Case
  doctest MyModule  # Test examples in @doc

  # Setup runs before each test
  setup do
    {:ok, data: "test data"}
  end

  # Group tests
  describe "function_name/1" do
    test "does something", %{data: data} do
      assert MyModule.function(data) == expected
    end

    test "handles errors" do
      assert_raise ArgumentError, fn ->
        MyModule.function(nil)
      end
    end
  end

  # Async tests (run in parallel)
  test "concurrent test", %{async: true} do
    # ...
  end
end

# Assertions
assert value == expected
assert value
refute value
assert_raise ExceptionType, fn -> code() end
assert_in_delta 3.14, 3.15, 0.01
```

## File I/O

```elixir
# Read
{:ok, content} = File.read("file.txt")
content = File.read!("file.txt")

# Write
File.write("file.txt", "content")
File.write!("file.txt", "content")

# Read lines
{:ok, lines} = File.read("file.txt")
lines = String.split(lines, "\n")

# Stream large files
File.stream!("large_file.txt")
|> Stream.map(&String.upcase/1)
|> Enum.to_list()

# Exists?
File.exists?("file.txt")

# Directory operations
File.mkdir("dir")
File.ls("dir")
File.rm_rf("dir")
```

## Common Operators

```elixir
# Arithmetic
1 + 2
5 - 3
2 * 3
10 / 2  # float division
div(10, 3)  # integer division
rem(10, 3)  # remainder

# Comparison
1 == 1    # equality
1 === 1   # strict equality (same type)
1 != 2    # inequality
1 !== 2   # strict inequality
1 < 2
1 <= 2
1 > 0
1 >= 1

# Logical
true and false
true or false
not true

# Boolean (short-circuit)
true && false
true || false
!true

# Membership
1 in [1, 2, 3]
:key in Map.keys(map)

# String concatenation
"hello" <> " world"

# List concatenation
[1, 2] ++ [3, 4]

# List subtraction
[1, 2, 3] -- [2]

# Pipe
value |> function()
```

## Mix Commands

```bash
# Create project
mix new project_name

# Compile
mix compile

# Run
mix run
mix run -e "Module.function()"

# Interactive shell
iex -S mix

# Tests
mix test
mix test --trace  # detailed output
mix test file_test.exs:10  # specific test

# Dependencies
mix deps.get
mix deps.update --all

# Format code
mix format

# Create executable
mix escript.build

# Documentation
mix docs

# Check for issues
mix credo
mix dialyzer
```

## IEx Commands

```elixir
# Help
h Module.function/1

# Info
i variable

# Compile and load file
c "file.exs"

# Reload module
r Module

# Clear screen
clear

# Exit
Ctrl+C (twice) or System.halt()

# See value of expression
v(1)  # value from first expression

# Re-run expression
v(-1) # last expression
```

## Common Patterns

### Option Keywords

```elixir
def request(url, opts \\ []) do
  timeout = Keyword.get(opts, :timeout, 5000)
  retry = Keyword.get(opts, :retry, 3)
  # ...
end

request("example.com", timeout: 3000, retry: 5)
```

### Updating Nested Maps

```elixir
# put_in / get_in / update_in
user = %{profile: %{name: "Alice"}}

get_in(user, [:profile, :name])
put_in(user, [:profile, :name], "Bob")
update_in(user, [:profile, :name], &String.upcase/1)
```

### Guards Reference

```elixir
is_atom(x)
is_binary(x)
is_boolean(x)
is_float(x)
is_function(x)
is_integer(x)
is_list(x)
is_map(x)
is_nil(x)
is_number(x)
is_tuple(x)

# Comparisons
x == y
x != y
x > y
x >= y

# Membership
x in [1, 2, 3]

# Type checks
is_nil(x)
```

## Sigils

```elixir
# Strings
~s(hello)  # string
~S(no #{interpolation})  # no interpolation

# Char lists
~c(hello)
~C(no #{interpolation})

# Regex
~r/pattern/
~r/pattern/i  # case insensitive

# Word lists
~w(foo bar baz)  # ["foo", "bar", "baz"]
~w(foo bar baz)a  # [:foo, :bar, :baz]

# Dates
~D[2024-01-15]
~T[10:30:00]
~N[2024-01-15 10:30:00]
```

## Useful Keyboard Shortcuts in IEx

- `Tab` - Autocomplete
- `Ctrl + R` - Reverse search history
- `Ctrl + A` - Beginning of line
- `Ctrl + E` - End of line
- `Ctrl + K` - Kill to end of line
- `Ctrl + C` (twice) - Exit IEx

---

This reference covers the most common Elixir patterns you'll use daily. Keep it handy while building your Task Tracker!
