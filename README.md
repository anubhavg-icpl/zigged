# Zigged - Zig Learning Project 🚀

A comprehensive Zig learning project by Anubhav showcasing fundamental concepts, build system, and testing in the Zig programming language.

## 📋 Project Overview

This project demonstrates a well-structured Zig application with:
- **Executable**: A simple "Hello World" style application with custom messaging
- **Library Module**: Reusable functions with proper module organization  
- **Testing Suite**: Unit tests and fuzz testing examples
- **Build System**: Complete Zig build configuration with multiple targets

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
- **Custom Print Statement**: "All your codebase are belong to us" message
- **Module Integration**: Imports and uses the custom `hello_world` module
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

## 🛠️ How to Use Examples

### Quick Start
```bash
# Build the project
zig build

# Run the main application  
zig build run
# Output: "All your codebase are belong to us."

# Run ALL example tests at once
zig build test
```

### Individual Example Testing
Each example file can be tested individually:

```bash
# Memory management examples
zig test src/memory_examples.zig

# String manipulation examples  
zig test src/strings_examples.zig

# File I/O examples
zig test src/file_io_examples.zig

# Error handling examples
zig test src/error_handling_examples.zig

# Data structures examples
zig test src/data_structures_examples.zig

# Concurrency examples (threading)
zig test src/concurrency_examples.zig

# Compile-time examples
zig test src/comptime_examples.zig
```

### Advanced Build Options
```bash
# Run with fuzz testing
zig build test -- --fuzz

# Build with optimization
zig build -Doptimize=ReleaseFast

# Verbose build output
zig build --verbose

# Clean build artifacts
rm -rf zig-out zig-cache
```

## 🧪 What Each Example Teaches

### 1. Memory Management (`memory_examples.zig`)
- **GPA & Arena Allocators**: Different allocation strategies
- **Slices & Pointers**: Memory views and references
- **Manual Memory Management**: Create, destroy, alloc, free

### 2. String Operations (`strings_examples.zig`)  
- **String Formatting**: bufPrint, allocPrint patterns
- **String Manipulation**: split, compare, contains, case conversion
- **Unicode Handling**: UTF-8 processing and code points

### 3. File I/O (`file_io_examples.zig`)
- **File Operations**: Create, read, write, append files
- **Directory Management**: Create, iterate, delete directories
- **JSON Handling**: Serialize and deserialize data

### 4. Error Handling (`error_handling_examples.zig`)
- **Custom Error Types**: Define application-specific errors
- **Error Propagation**: try/catch patterns and chaining
- **Resource Cleanup**: defer statements for proper cleanup

### 5. Data Structures (`data_structures_examples.zig`)
- **Dynamic Arrays**: ArrayList operations and resizing
- **Hash Maps**: Key-value storage with custom hash functions
- **Custom Structures**: Queue, Stack, and LinkedList implementations

### 6. Concurrency (`concurrency_examples.zig`)
- **Threading**: Create and manage multiple threads
- **Synchronization**: Mutexes, atomic operations, condition variables
- **Communication**: Producer-consumer and channel patterns

### 7. Compile-time Programming (`comptime_examples.zig`)
- **Generic Types**: Create reusable data structures
- **Type Introspection**: Examine types at compile-time
- **Compile-time Computation**: Calculate values during compilation

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