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
├── build.zig          # Build configuration and targets
├── build.zig.zon      # Package manifest and dependencies
├── src/
│   ├── main.zig       # Application entry point
│   └── root.zig       # Library module with reusable functions
├── zig-out/           # Build output directory
│   └── bin/
└── .gitignore         # Git ignore patterns for Zig projects
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

## 🛠️ Build Commands

```bash
# Build the project
zig build

# Run the application
zig build run

# Run all tests
zig build test

# Run with fuzz testing
zig build test -- --fuzz

# Build with optimization
zig build -Doptimize=ReleaseFast
```

## 🧪 Testing

The project includes comprehensive testing:

1. **Unit Tests**: Basic functionality verification
2. **Memory Management Tests**: ArrayList operations with proper cleanup
3. **Fuzz Testing**: Automated edge case discovery
4. **Module Tests**: Library function validation

Run tests with: `zig build test`

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