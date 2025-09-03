const std = @import("std");
const print = std.debug.print;

// Custom error types
const MathError = error{
    DivisionByZero,
    NegativeSquareRoot,
    Overflow,
};

const FileError = error{
    FileNotFound,
    PermissionDenied,
    DiskFull,
};

// Combined error set
const AppError = MathError || FileError || std.mem.Allocator.Error;

pub fn demonstrateBasicErrors() void {
    print("=== Basic Error Handling ===\n");
    
    // Function that can return an error
    const divide = struct {
        fn call(a: i32, b: i32) MathError!i32 {
            if (b == 0) return MathError.DivisionByZero;
            return @divTrunc(a, b);
        }
    }.call;
    
    // Try-catch pattern
    const result = divide(10, 2) catch |err| {
        print("Division error: {}\n", .{err});
        return;
    };
    print("10 / 2 = {}\n", .{result});
    
    // Handle error explicitly
    if (divide(10, 0)) |value| {
        print("Result: {}\n", .{value});
    } else |err| {
        print("Error occurred: {}\n", .{err});
    }
}

pub fn demonstrateErrorPropagation() AppError!void {
    print("\n=== Error Propagation ===\n");
    
    const safeDivide = struct {
        fn call(a: f32, b: f32) MathError!f32 {
            if (b == 0.0) return MathError.DivisionByZero;
            return a / b;
        }
    }.call;
    
    const safeSquareRoot = struct {
        fn call(x: f32) MathError!f32 {
            if (x < 0.0) return MathError.NegativeSquareRoot;
            return @sqrt(x);
        }
    }.call;
    
    // Chain operations with error propagation
    const chainedOperation = struct {
        fn call(a: f32, b: f32) MathError!f32 {
            const divided = try safeDivide(a, b);
            const result = try safeSquareRoot(divided);
            return result;
        }
    }.call;
    
    // Success case
    if (chainedOperation(16.0, 4.0)) |result| {
        print("sqrt(16/4) = {d:.2}\n", .{result});
    } else |err| {
        print("Chained operation failed: {}\n", .{err});
    }
    
    // Error case - division by zero
    if (chainedOperation(16.0, 0.0)) |result| {
        print("Result: {d:.2}\n", .{result});
    } else |err| {
        print("Chained operation failed: {}\n", .{err});
    }
    
    // Error case - negative square root
    if (chainedOperation(-16.0, 4.0)) |result| {
        print("Result: {d:.2}\n", .{result});
    } else |err| {
        print("Chained operation failed: {}\n", .{err});
    }
}

pub fn demonstrateErrorUnions() !void {
    print("\n=== Error Unions and Switch ===\n");
    
    const parseNumber = struct {
        fn call(str: []const u8) AppError!i32 {
            return std.fmt.parseInt(i32, str, 10) catch |err| switch (err) {
                error.InvalidCharacter => {
                    print("Invalid character in: '{s}'\n", .{str});
                    return err;
                },
                error.Overflow => {
                    print("Number too large: '{s}'\n", .{str});
                    return MathError.Overflow;
                },
                else => return err,
            };
        }
    }.call;
    
    const test_strings = [_][]const u8{ "123", "abc", "999999999999999999999" };
    
    for (test_strings) |str| {
        switch (parseNumber(str)) {
            MathError.Overflow => print("Handled overflow for '{s}'\n", .{str}),
            else => |result| {
                if (result) |num| {
                    print("Parsed '{s}' -> {}\n", .{ str, num });
                } else |err| {
                    print("Parse error for '{s}': {}\n", .{ str, err });
                }
            },
        }
    }
}

pub fn demonstrateDefer() AppError!void {
    print("\n=== Defer and Error Cleanup ===\n");
    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    const processData = struct {
        fn call(alloc: std.mem.Allocator, should_fail: bool) AppError!void {
            // Allocate resources
            const buffer1 = try alloc.alloc(u8, 100);
            defer alloc.free(buffer1); // Always executed
            
            const buffer2 = try alloc.alloc(u8, 200);
            defer alloc.free(buffer2);
            
            // Defer with error handling
            defer print("Cleanup completed\n");
            
            print("Processing data...\n");
            
            if (should_fail) {
                print("Simulating error during processing\n");
                return FileError.PermissionDenied;
            }
            
            print("Processing successful\n");
        }
    }.call;
    
    // Success case
    print("Case 1 - Success:\n");
    if (processData(allocator, false)) {
        print("Operation completed successfully\n");
    } else |err| {
        print("Operation failed: {}\n", .{err});
    }
    
    print("\nCase 2 - Failure:\n");
    if (processData(allocator, true)) {
        print("Operation completed successfully\n");
    } else |err| {
        print("Operation failed: {}\n", .{err});
    }
}

pub fn demonstrateErrorReturn() void {
    print("\n=== Error Return Patterns ===\n");
    
    const Result = union(enum) {
        success: i32,
        failure: []const u8,
    };
    
    const processValue = struct {
        fn call(value: i32) Result {
            if (value < 0) {
                return Result{ .failure = "Negative values not allowed" };
            }
            if (value > 100) {
                return Result{ .failure = "Value too large" };
            }
            return Result{ .success = value * 2 };
        }
    }.call;
    
    const test_values = [_]i32{ 42, -5, 150 };
    
    for (test_values) |value| {
        const result = processValue(value);
        switch (result) {
            .success => |val| print("Success: {} -> {}\n", .{ value, val }),
            .failure => |err| print("Error for {}: {s}\n", .{ value, err }),
        }
    }
}

pub fn demonstrateOptionals() void {
    print("\n=== Optionals vs Errors ===\n");
    
    const findIndex = struct {
        fn call(slice: []const i32, target: i32) ?usize {
            for (slice, 0..) |item, index| {
                if (item == target) return index;
            }
            return null;
        }
    }.call;
    
    const numbers = [_]i32{ 10, 20, 30, 40, 50 };
    
    // Optional handling
    if (findIndex(numbers[0..], 30)) |index| {
        print("Found 30 at index {}\n", .{index});
    } else {
        print("30 not found\n");
    }
    
    // Optional with default
    const index = findIndex(numbers[0..], 99) orelse 999;
    print("Index of 99 (or default): {}\n", .{index});
    
    // Optional unwrap
    const maybe_value: ?i32 = 42;
    const unwrapped = maybe_value.?; // Panic if null
    print("Unwrapped value: {}\n", .{unwrapped});
}

test "error handling examples" {
    demonstrateBasicErrors();
    try demonstrateErrorPropagation();
    try demonstrateErrorUnions();
    try demonstrateDefer();
    demonstrateErrorReturn();
    demonstrateOptionals();
}