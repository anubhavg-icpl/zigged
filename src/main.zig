const std = @import("std");
const hello_world = @import("hello_world");
const memory_examples = @import("memory_examples");
const strings_examples = @import("strings_examples");
const file_io_examples = @import("file_io_examples");
const error_handling_examples = @import("error_handling_examples");
const data_structures_examples = @import("data_structures_examples");
const concurrency_examples = @import("concurrency_examples");
const comptime_examples = @import("comptime_examples");

const print = std.debug.print;

fn printUsage() void {
    print("\n🦎 Zigged - Zig Learning Examples CLI\n\n", .{});
    print("Usage: zig build run -- [example]\n\n", .{});
    print("Available examples:\n", .{});
    print("  memory       - Memory management (allocators, slices, pointers)\n", .{});
    print("  strings      - String operations (formatting, manipulation, unicode)\n", .{});
    print("  file-io      - File I/O operations (files, directories, JSON)\n", .{});
    print("  errors       - Error handling (custom errors, propagation, cleanup)\n", .{});
    print("  data         - Data structures (arrays, maps, stacks, queues)\n", .{});
    print("  concurrency  - Threading and synchronization\n", .{});
    print("  comptime     - Compile-time programming (generics, introspection)\n", .{});
    print("  all          - Run all examples\n\n", .{});
    print("Examples:\n", .{});
    print("  zig build run -- memory\n", .{});
    print("  zig build run -- strings\n", .{});
    print("  zig build run -- all\n\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    
    if (args.len < 2) {
        print("All your {s} are belong to us.\n", .{"codebase"});
        try hello_world.bufferedPrint();
        printUsage();
        return;
    }
    
    const example = args[1];
    
    if (std.mem.eql(u8, example, "memory")) {
        print("\n🧠 Running Memory Management Examples\n", .{});
        print("=====================================\n", .{});
        try memory_examples.demonstrateAllocators();
        memory_examples.demonstrateSlices();
        memory_examples.demonstratePointers();
    } else if (std.mem.eql(u8, example, "strings")) {
        print("\n📝 Running String Examples\n", .{});
        print("===========================\n", .{});
        strings_examples.demonstrateStringBasics();
        try strings_examples.demonstrateStringFormatting(allocator);
        try strings_examples.demonstrateStringOperations(allocator);
        try strings_examples.demonstrateStringBuilder(allocator);
        try strings_examples.demonstrateUnicodeStrings();
    } else if (std.mem.eql(u8, example, "file-io")) {
        print("\n📁 Running File I/O Examples\n", .{});
        print("=============================\n", .{});
        try file_io_examples.demonstrateFileOperations(allocator);
        try file_io_examples.demonstrateDirectoryOperations();
        try file_io_examples.demonstrateFileStreams(allocator);
    } else if (std.mem.eql(u8, example, "errors")) {
        print("\n⚠️  Running Error Handling Examples\n", .{});
        print("====================================\n", .{});
        error_handling_examples.demonstrateBasicErrors();
        try error_handling_examples.demonstrateErrorPropagation();
        try error_handling_examples.demonstrateErrorUnions();
        try error_handling_examples.demonstrateDefer();
        error_handling_examples.demonstrateErrorReturn();
        error_handling_examples.demonstrateOptionals();
    } else if (std.mem.eql(u8, example, "data")) {
        print("\n📊 Running Data Structures Examples\n", .{});
        print("====================================\n", .{});
        data_structures_examples.demonstrateArrays();
        try data_structures_examples.demonstrateArrayList(allocator);
        try data_structures_examples.demonstrateHashMaps(allocator);
        try data_structures_examples.demonstrateLinkedList(allocator);
        try data_structures_examples.demonstrateQueue(allocator);
        try data_structures_examples.demonstrateStack(allocator);
    } else if (std.mem.eql(u8, example, "concurrency")) {
        print("\n🔄 Running Concurrency Examples\n", .{});
        print("================================\n", .{});
        try concurrency_examples.demonstrateBasicThreads(allocator);
        try concurrency_examples.demonstrateMutex(allocator);
        try concurrency_examples.demonstrateAtomics();
        try concurrency_examples.demonstrateProducerConsumer(allocator);
        try concurrency_examples.demonstrateChannels(allocator);
    } else if (std.mem.eql(u8, example, "comptime")) {
        print("\n⚡ Running Compile-time Examples\n", .{});
        print("================================\n", .{});
        comptime_examples.demonstrateComptimeBasics();
        comptime_examples.demonstrateComptimeFunctions();
        comptime_examples.demonstrateGenericTypes();
        comptime_examples.demonstrateTypeIntrospection();
        comptime_examples.demonstrateComptimeArrays();
        comptime_examples.demonstrateComptimeSwitch();
    } else if (std.mem.eql(u8, example, "all")) {
        print("\n🚀 Running ALL Examples\n", .{});
        print("========================\n\n", .{});
        
        print("🧠 Memory Management:\n", .{});
        try memory_examples.demonstrateAllocators();
        memory_examples.demonstrateSlices();
        memory_examples.demonstratePointers();
        
        print("\n📝 String Operations:\n", .{});
        strings_examples.demonstrateStringBasics();
        try strings_examples.demonstrateStringFormatting(allocator);
        try strings_examples.demonstrateStringOperations(allocator);
        try strings_examples.demonstrateStringBuilder(allocator);
        try strings_examples.demonstrateUnicodeStrings();
        
        print("\n📁 File I/O:\n", .{});
        try file_io_examples.demonstrateFileOperations(allocator);
        try file_io_examples.demonstrateDirectoryOperations();
        try file_io_examples.demonstrateFileStreams(allocator);
        
        print("\n⚠️  Error Handling:\n", .{});
        error_handling_examples.demonstrateBasicErrors();
        try error_handling_examples.demonstrateErrorPropagation();
        try error_handling_examples.demonstrateErrorUnions();
        try error_handling_examples.demonstrateDefer();
        error_handling_examples.demonstrateErrorReturn();
        error_handling_examples.demonstrateOptionals();
        
        print("\n📊 Data Structures:\n", .{});
        data_structures_examples.demonstrateArrays();
        try data_structures_examples.demonstrateArrayList(allocator);
        try data_structures_examples.demonstrateHashMaps(allocator);
        try data_structures_examples.demonstrateLinkedList(allocator);
        try data_structures_examples.demonstrateQueue(allocator);
        try data_structures_examples.demonstrateStack(allocator);
        
        print("\n🔄 Concurrency:\n", .{});
        try concurrency_examples.demonstrateBasicThreads(allocator);
        try concurrency_examples.demonstrateMutex(allocator);
        try concurrency_examples.demonstrateAtomics();
        try concurrency_examples.demonstrateProducerConsumer(allocator);
        try concurrency_examples.demonstrateChannels(allocator);
        
        print("\n⚡ Compile-time Programming:\n", .{});
        comptime_examples.demonstrateComptimeBasics();
        comptime_examples.demonstrateComptimeFunctions();
        comptime_examples.demonstrateGenericTypes();
        comptime_examples.demonstrateTypeIntrospection();
        comptime_examples.demonstrateComptimeArrays();
        comptime_examples.demonstrateComptimeSwitch();
        
        print("\n✅ All examples completed!\n", .{});
    } else {
        print("❌ Unknown example: '{s}'\n", .{example});
        printUsage();
        return;
    }
    
    print("\n🎉 Example completed successfully!\n", .{});
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
