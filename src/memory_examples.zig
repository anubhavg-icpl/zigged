const std = @import("std");
const print = std.debug.print;

pub fn demonstrateAllocators() !void {
    // GPA (General Purpose Allocator) - tracks memory leaks
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const gpa_allocator = gpa.allocator();
    
    // Arena allocator - batch free all allocations
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    
    print("=== Memory Management Examples ===\n", .{});
    
    // Single value allocation
    const single_int = try gpa_allocator.create(i32);
    defer gpa_allocator.destroy(single_int);
    single_int.* = 42;
    print("Single allocation: {}\n", .{single_int.*});
    
    // Array allocation
    const numbers = try gpa_allocator.alloc(i32, 5);
    defer gpa_allocator.free(numbers);
    for (numbers, 0..) |*num, i| {
        num.* = @intCast(i * 10);
    }
    print("Array: {any}\n", .{numbers});
    
    // Arena allocation (no individual free needed)
    const arena_strings = try arena_allocator.alloc([]const u8, 3);
    arena_strings[0] = "Hello";
    arena_strings[1] = "Zig";
    arena_strings[2] = "World";
    print("Arena strings: {s}\n", .{arena_strings});
}

pub fn demonstrateSlices() void {
    print("\n=== Slice Examples ===\n", .{});
    
    var array = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 };
    
    // Full slice
    const full_slice = array[0..];
    print("Full slice: {any}\n", .{full_slice});
    
    // Partial slice
    const partial = array[2..5];
    print("Partial slice [2..5]: {any}\n", .{partial});
    
    // Slice with sentinel
    const sentence = "Hello, Zig!";
    const word = sentence[0..5];
    print("String slice: '{s}'\n", .{word});
}

pub fn demonstratePointers() void {
    print("\n=== Pointer Examples ===\n", .{});
    
    var value: i32 = 100;
    const ptr = &value;
    
    print("Value: {}, Pointer: {*}, Dereferenced: {}\n", .{ value, ptr, ptr.* });
    
    // Modify through pointer
    ptr.* = 200;
    print("After modification: {}\n", .{value});
    
    // Multi-item pointer
    var nums = [_]i32{ 10, 20, 30 };
    const multi_ptr: [*]i32 = &nums;
    
    print("Multi-item pointer access: {} {} {}\n", .{ multi_ptr[0], multi_ptr[1], multi_ptr[2] });
}

test "memory management" {
    try demonstrateAllocators();
    demonstrateSlices();
    demonstratePointers();
}