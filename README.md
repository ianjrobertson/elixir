# Task Tracker CLI - Learn Elixir by Building

A progressive learning project designed to teach you Elixir fundamentals by building a practical command-line task management application.

## 🎯 Learning Objectives

This project will teach you:
- Core Elixir syntax and patterns
- Functional programming concepts
- Pattern matching and data transformation
- OTP basics (GenServer)
- Testing with ExUnit
- Working with Mix projects
- File I/O and data persistence

## 📚 Project Structure

```
task_tracker/
├── README.md
├── LEARNING_GUIDE.md      # Step-by-step tutorials
├── CONCEPTS.md            # Elixir concepts explained
├── EXERCISES.md           # Practice exercises
├── mix.exs
├── lib/
│   ├── task_tracker.ex
│   ├── task.ex
│   ├── cli.ex
│   └── storage.ex
└── test/
    ├── task_test.exs
    ├── cli_test.exs
    └── storage_test.exs
```

## 🚀 Getting Started

### Prerequisites

1. Install Elixir (version 1.14 or higher)
   ```bash
   # macOS
   brew install elixir

   # Ubuntu/Debian
   sudo apt-get install elixir

   # Or visit: https://elixir-lang.org/install.html
   ```

2. Verify installation:
   ```bash
   elixir --version
   ```

### Project Setup

1. Create the Mix project:
   ```bash
   mix new task_tracker
   cd task_tracker
   ```

2. Follow the learning guide in `LEARNING_GUIDE.md`

## 📖 Documentation

- **[LEARNING_GUIDE.md](./LEARNING_GUIDE.md)** - Step-by-step implementation guide
- **[CONCEPTS.md](./CONCEPTS.md)** - Elixir concepts explained with examples
- **[EXERCISES.md](./EXERCISES.md)** - Practice exercises for each phase
- **[REFERENCE.md](./REFERENCE.md)** - Quick reference and cheat sheet

## 🎓 Learning Phases

### Phase 1: Fundamentals (Beginner)
**Goal:** Learn basic Elixir syntax and functional programming

Features to build:
- Task struct definition
- Add new tasks
- List all tasks
- Basic pattern matching
- Working with lists and maps

**Key Concepts:** Modules, functions, structs, pattern matching, Enum

### Phase 2: Intermediate Features
**Goal:** Learn data transformation and state management

Features to build:
- Mark tasks complete/incomplete
- Delete tasks
- Filter and search tasks
- Save/load from file
- Add priorities and due dates

**Key Concepts:** Pipe operator, recursion, File I/O, error handling, GenServer

### Phase 3: Advanced Features
**Goal:** Master advanced patterns and OTP

Features to build:
- Task dependencies
- Statistics and reporting
- Export to multiple formats
- Undo/redo functionality
- Command history

**Key Concepts:** Advanced GenServer, supervisors, protocols, macros

## 🏃 Quick Start Example

After completing Phase 1, you'll be able to run:

```bash
# Compile and run
mix run -e "TaskTracker.CLI.main()"

# Or create an escript
mix escript.build
./task_tracker add "Learn Elixir pattern matching"
./task_tracker list
./task_tracker complete 1
```

## 🧪 Testing

Run tests:
```bash
mix test
```

Run tests with coverage:
```bash
mix test --cover
```

## 📝 Feature Roadmap

- [x] Project structure and documentation
- [ ] Phase 1: Basic task management
- [ ] Phase 2: Persistence and filtering
- [ ] Phase 3: Advanced features

## 🤝 Learning Tips

1. **Read the error messages** - Elixir has excellent error messages
2. **Use IEx** - The interactive shell is your friend (`iex -S mix`)
3. **Write tests first** - TDD helps you understand the expected behavior
4. **Experiment** - Try breaking things to understand how they work
5. **Read the docs** - `h Module.function` in IEx shows documentation

## 📚 Additional Resources

- [Official Elixir Guides](https://elixir-lang.org/getting-started/introduction.html)
- [Elixir School](https://elixirschool.com/)
- [Exercism Elixir Track](https://exercism.org/tracks/elixir)
- [Elixir Forum](https://elixirforum.com/)

## 🎯 Next Steps

1. Read through `CONCEPTS.md` to understand Elixir fundamentals
2. Follow `LEARNING_GUIDE.md` Phase 1 to build your first features
3. Complete exercises in `EXERCISES.md` to reinforce learning
4. Experiment and add your own features!

Happy learning! 🎉
