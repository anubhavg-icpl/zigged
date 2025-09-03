const std = @import("std");
const print = std.debug.print;

// Import all example modules
const error_handling = @import("error_handling_examples.zig");
const file_io = @import("file_io_examples.zig");
const data_structures = @import("data_structures_examples.zig");
const concurrency = @import("concurrency_examples.zig");
const comptime_examples = @import("comptime_examples.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("🦎 Zigged - Zig Learning Examples CLI\n\n", .{});
        print("Usage: zig build run -- [example]\n\n", .{});
        print("Available examples:\n", .{});
        print("  basic       - Basic Zig syntax and operations\n", .{});
        print("  memory      - Memory management basics\n", .{});
        print("  strings     - String operations\n", .{});
        print("  arrays      - Array and slice examples\n", .{});
        print("  errors      - Error handling patterns\n", .{});
        print("  file-io     - File I/O operations\n", .{});
        print("  data        - Data structures (ArrayList, HashMap, etc.)\n", .{});
        print("  concurrency - Threading and synchronization\n", .{});
        print("  comptime    - Compile-time programming\n", .{});
        print("  all         - Run all basic examples\n", .{});
        print("  advanced    - Run all advanced examples\n\n", .{});
        return;
    }
    
    const example = args[1];
    
    if (std.mem.eql(u8, example, "basic")) {
        print("\n⚡ Basic Zig Examples\n", .{});
        print("====================\n", .{});
        demonstrateBasics();
    } else if (std.mem.eql(u8, example, "memory")) {
        print("\n🧠 Memory Examples\n", .{});
        print("==================\n", .{});
        try demonstrateMemory(allocator);
    } else if (std.mem.eql(u8, example, "strings")) {
        print("\n📝 String Examples\n", .{});
        print("==================\n", .{});
        try demonstrateStrings(allocator);
    } else if (std.mem.eql(u8, example, "arrays")) {
        print("\n📊 Array Examples\n", .{});
        print("=================\n", .{});
        demonstrateArrays();
    } else if (std.mem.eql(u8, example, "errors")) {
        print("\n⚠️ Error Handling Examples\n", .{});
        print("=========================\n", .{});
        error_handling.demonstrateBasicErrors();
        try error_handling.demonstrateErrorPropagation();
        try error_handling.demonstrateErrorUnions();
        try error_handling.demonstrateDefer();
        error_handling.demonstrateErrorReturn();
        error_handling.demonstrateOptionals();
    } else if (std.mem.eql(u8, example, "file-io")) {
        print("\n📁 File I/O Examples\n", .{});
        print("===================\n", .{});
        try file_io.demonstrateFileOperations(allocator);
        try file_io.demonstrateDirectoryOperations();
        try file_io.demonstrateFileStreams(allocator);
    } else if (std.mem.eql(u8, example, "data")) {
        print("\n📊 Data Structure Examples\n", .{});
        print("=========================\n", .{});
        data_structures.demonstrateArrays();
        try data_structures.demonstrateArrayList(allocator);
        try data_structures.demonstrateHashMaps(allocator);
        try data_structures.demonstrateLinkedList(allocator);
        try data_structures.demonstrateQueue(allocator);
        try data_structures.demonstrateStack(allocator);
    } else if (std.mem.eql(u8, example, "concurrency")) {
        print("\n🔄 Concurrency Examples\n", .{});
        print("=======================\n", .{});
        try concurrency.demonstrateBasicThreads(allocator);
        try concurrency.demonstrateMutex(allocator);
        try concurrency.demonstrateAtomics();
        try concurrency.demonstrateProducerConsumer(allocator);
        try concurrency.demonstrateChannels(allocator);
    } else if (std.mem.eql(u8, example, "comptime")) {
        print("\n⚡ Compile-time Programming Examples\n", .{});
        print("====================================\n", .{});
        comptime_examples.demonstrateComptimeBasics();
        comptime_examples.demonstrateComptimeFunctions();
        try comptime_examples.demonstrateGenericTypes();
        comptime_examples.demonstrateTypeIntrospection();
        comptime_examples.demonstrateComptimeArrays();
        comptime_examples.demonstrateComptimeSwitch();
    } else if (std.mem.eql(u8, example, "all")) {
        print("\n🚀 All Basic Examples\n", .{});
        print("=====================\n\n", .{});
        
        print("⚡ Basic Zig:\n", .{});
        demonstrateBasics();
        
        print("\n🧠 Memory Management:\n", .{});
        try demonstrateMemory(allocator);
        
        print("\n📝 String Operations:\n", .{});
        try demonstrateStrings(allocator);
        
        print("\n📊 Arrays and Slices:\n", .{});
        demonstrateArrays();
        
        print("\n✅ All basic examples completed!\n", .{});
    } else if (std.mem.eql(u8, example, "advanced")) {
        print("\n🚀 All Advanced Examples\n", .{});
        print("========================\n\n", .{});
        
        print("⚠️ Error Handling:\n", .{});
        error_handling.demonstrateBasicErrors();
        
        print("\n📁 File I/O:\n", .{});
        try file_io.demonstrateFileOperations(allocator);
        
        print("\n📊 Data Structures:\n", .{});
        data_structures.demonstrateArrays();
        
        print("\n🔄 Concurrency:\n", .{});
        try concurrency.demonstrateBasicThreads(allocator);
        
        print("\n⚡ Compile-time Programming:\n", .{});
        comptime_examples.demonstrateComptimeBasics();
        
        print("\n✅ All advanced examples completed!\n", .{});
    } else {
        print("❌ Unknown example: '{s}'\n", .{example});
        print("Run without arguments to see available examples.\n", .{});
        return;
    }
    
    print("\n🎉 Example completed successfully!\n", .{});
}

fn demonstrateBasics() void {
    print("Variables and Constants:\n", .{});
    const pi: f32 = 3.14159;
    var counter: i32 = 0;
    counter += 10;
    
    print("  π = {d:.2}\n", .{pi});
    print("  counter = {}\n", .{counter});
    
    print("\nControlFlow:\n", .{});
    for (0..5) |i| {
        if (i % 2 == 0) {
            print("  {} is even\n", .{i});
        } else {
            print("  {} is odd\n", .{i});
        }
    }
}

fn demonstrateMemory(allocator: std.mem.Allocator) !void {
    print("Dynamic allocation:\n", .{});
    
    // Single value
    const number = try allocator.create(i32);
    defer allocator.destroy(number);
    number.* = 42;
    print("  Allocated number: {}\n", .{number.*});
    
    // Array
    const array = try allocator.alloc(i32, 5);
    defer allocator.free(array);
    
    for (array, 0..) |*item, i| {
        item.* = @intCast(i * 2);
    }
    print("  Allocated array: ", .{});
    for (array) |item| {
        print("{} ", .{item});
    }
    print("\n", .{});
}

fn demonstrateStrings(allocator: std.mem.Allocator) !void {
    print("String operations:\n", .{});
    
    const hello = "Hello, Zig!";
    print("  String: '{s}' (length: {})\n", .{ hello, hello.len });
    
    // Format string
    const formatted = try std.fmt.allocPrint(allocator, "Number: {}, Boolean: {}", .{ 42, true });
    defer allocator.free(formatted);
    print("  Formatted: '{s}'\n", .{formatted});
    
    // String comparison
    const str1 = "apple";
    const str2 = "apple";
    print("  '{s}' == '{s}': {}\n", .{ str1, str2, std.mem.eql(u8, str1, str2) });
}

fn demonstrateArrays() void {
    print("Arrays and slices:\n", .{});
    
    // Fixed array
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    print("  Array: ", .{});
    for (numbers) |num| {
        print("{} ", .{num});
    }
    print("\n", .{});
    
    // Slice
    const slice = numbers[1..4];
    print("  Slice [1..4]: ", .{});
    for (slice) |num| {
        print("{} ", .{num});
    }
    print("\n", .{});
    
    // Multi-dimensional
    const matrix = [2][3]i32{
        [_]i32{ 1, 2, 3 },
        [_]i32{ 4, 5, 6 },
    };
    print("  Matrix:\n", .{});
    for (matrix) |row| {
        print("    ", .{});
        for (row) |cell| {
            print("{} ", .{cell});
        }
        print("\n", .{});
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa);
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}