# Zigged - Zig Learning Project 🦎

A comprehensive interactive Zig learning CLI by Anubhav showcasing fundamental concepts through hands-on examples.

## 📋 Project Overview

This project is a fully functional CLI application that teaches Zig programming through interactive examples:
- **Interactive CLI**: Learn by running specific examples with immediate feedback
- **Comprehensive Examples**: From basic syntax to advanced memory management
- **Testing Suite**: Unit tests and fuzz testing examples
- **Build System**: Complete Zig build configuration supporting the CLI interface

## 🏗️ Project Structure

```
hello-world/
├── build.zig                    # Build configuration and targets
├── build.zig.zon                # Package manifest and dependencies
├── src/
│   ├── main.zig                 # Application entry point
│   ├── root.zig                 # Library module with reusable functions
│   ├── memory_examples.zig      # Memory management demonstrations
│   ├── strings_examples.zig     # String manipulation examples
│   ├── file_io_examples.zig     # File I/O operations
│   ├── error_handling_examples.zig # Error handling patterns
│   ├── data_structures_examples.zig # Data structures implementations
│   ├── concurrency_examples.zig # Threading and synchronization
│   └── comptime_examples.zig    # Compile-time programming
├── zig-out/                     # Build output directory
│   └── bin/
└── .gitignore                   # Git ignore patterns for Zig projects
```

## ✨ Features

### Main Application (`src/main.zig`)
- **Interactive CLI Interface**: Command-line argument parsing for example selection
- **Integrated Examples**: All basic examples built into the main application
- **Learning-Focused**: Clear help menu and structured example progression
- **Unit Testing**: Simple ArrayList test with memory management
- **Fuzz Testing**: Advanced fuzzing example to find edge cases

### Library Module (`src/root.zig`)
- **Buffered Output**: Demonstrates proper stdout handling with buffering
- **Utility Functions**: Basic arithmetic functions (add operation)
- **Test Coverage**: Unit tests for library functions

### Build System (`build.zig`)
- **Dual Architecture**: Both executable and library module setup
- **Multiple Targets**: Support for various build targets and optimizations
- **Test Integration**: Comprehensive test runner configuration
- **CLI Support**: Command-line argument passing capability

## 🛠️ CLI Usage - Interactive Learning

### 🚀 **Main CLI Interface**
```bash
# Show help menu and available examples
zig build run

# Run specific examples interactively
zig build run -- basic          # ⚡ Basic Zig syntax and operations
zig build run -- memory         # 🧠 Memory management basics
zig build run -- strings        # 📝 String operations
zig build run -- arrays         # 📊 Array and slice examples

# Run ALL examples in sequence  
zig build run -- all            # 🎯 Complete walkthrough
```

### 🧪 **Testing the Example Files**  
Test the underlying example files individually:

```bash
# Individual test commands for example files
zig build test-memory            # Memory management examples
zig build test-strings           # String manipulation examples  
zig build test-file-io           # File I/O operation examples
zig build test-error-handling    # Error handling pattern examples
zig build test-data-structures   # Data structure examples
zig build test-concurrency       # Threading and concurrency examples
zig build test-comptime          # Compile-time programming examples

# Run all tests (traditional)
zig build test                   # Everything at once
```

### 🔧 **Direct File Testing**
For advanced users who want to test files directly:

```bash
# Direct file testing (bypass build system)
zig test src/memory_examples.zig
zig test src/strings_examples.zig
zig test src/file_io_examples.zig
# ... etc
```

### ⚙️ **Advanced Options**
```bash
# Build optimizations
zig build -Doptimize=ReleaseFast
zig build -Doptimize=ReleaseSmall

# Verbose output for debugging
zig build --verbose
zig build test --verbose

# Fuzzing (for compatible tests)
zig build test -- --fuzz

# Clean build artifacts  
rm -rf zig-out zig-cache
```

## 🧪 What the CLI Examples Teach

### 1. **basic** - Basic Zig Syntax and Operations
- **Variables & Constants**: Understanding `var` vs `const`, type inference
- **Control Flow**: for loops, if statements, basic iteration
- **Basic Arithmetic**: Simple mathematical operations

### 2. **memory** - Memory Management Basics
- **GPA Allocator**: General Purpose Allocator usage  
- **Dynamic Allocation**: Creating and freeing memory manually
- **Array Operations**: Working with dynamically allocated arrays

### 3. **strings** - String Operations  
- **String Formatting**: Using `std.fmt.allocPrint` for formatting
- **String Comparison**: Using `std.mem.eql` for string equality
- **String Literals**: Working with string constants and slices

### 4. **arrays** - Array and Slice Examples
- **Fixed Arrays**: Compile-time known size arrays
- **Slices**: Views into arrays with runtime bounds
- **Multi-dimensional Arrays**: Matrices and nested data structures

### 5. **all** - Complete Learning Walkthrough
- Runs all the above examples in sequence for comprehensive learning
- Shows the progression from basic syntax to more complex concepts

## 📚 Additional Learning Resources (Example Files)

While the CLI focuses on core concepts, the project includes comprehensive example files covering advanced topics:

- `memory_examples.zig` - Advanced memory management with GPA & Arena allocators
- `strings_examples.zig` - Unicode handling, string manipulation, formatting
- `file_io_examples.zig` - File operations, directories, JSON processing  
- `error_handling_examples.zig` - Custom errors, propagation, cleanup patterns
- `data_structures_examples.zig` - ArrayList, HashMap, LinkedList, Queue, Stack
- `concurrency_examples.zig` - Threading, mutexes, atomics, producer-consumer
- `comptime_examples.zig` - Compile-time programming, generics, type introspection

## 📦 Dependencies

- **Zig Version**: Minimum 0.15.1
- **No External Dependencies**: Pure Zig implementation using only standard library

## 🎯 Learning Objectives

This project covers essential Zig concepts:

- ✅ **Module System**: Proper module organization and imports
- ✅ **Memory Management**: Manual memory allocation and cleanup
- ✅ **Error Handling**: Try-catch patterns and error propagation
- ✅ **Testing Framework**: Unit tests and fuzz testing
- ✅ **Build System**: Complex build configurations
- ✅ **Standard Library**: File I/O, allocators, and data structures

## 🚀 Getting Started

1. **Clone the repository**:
   ```bash
   git clone git@github.com:anubhavg-icpl/zigged.git
   cd zigged
   ```

2. **Build and run**:
   ```bash
   zig build run
   ```

3. **Run tests**:
   ```bash
   zig build test
   ```

## 📖 Code Highlights

### Buffered Output Function
```zig
pub fn bufferedPrint() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    
    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try stdout.flush();
}
```

### Fuzz Testing Example
```zig
test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
```

## 🎓 Next Steps for Learning

- Explore more complex data structures
- Implement error handling patterns
- Study memory allocator strategies  
- Build network or file I/O applications
- Investigate Zig's compile-time features

---

**Happy Zigging!** 🦎

*This project serves as a foundation for learning Zig programming language fundamentals and best practices.*