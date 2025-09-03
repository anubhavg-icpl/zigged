const std = @import("std");
const print = std.debug.print;

pub fn demonstrateComptimeBasics() void {
    print("=== Compile-time Basics ===\n");
    
    // Compile-time constants
    const comptime_value = comptime 5 * 10 + 3;
    print("Compile-time calculated value: {}\n", .{comptime_value});
    
    // Compile-time string concatenation
    const greeting = "Hello";
    const target = "Zig";
    const message = comptime greeting ++ ", " ++ target ++ "!";
    print("Compile-time string: {s}\n", .{message});
    
    // Compile-time array generation
    const squares = comptime blk: {
        var arr: [10]i32 = undefined;
        for (&arr, 0..) |*item, i| {
            item.* = @intCast(i * i);
        }
        break :blk arr;
    };
    print("Compile-time generated squares: {any}\n", .{squares[0..5]});
}

pub fn demonstrateComptimeFunctions() void {
    print("\n=== Compile-time Functions ===\n");
    
    const fibonacci = comptime blk: {
        const fib = struct {
            fn calc(n: comptime_int) comptime_int {
                if (n <= 1) return n;
                return calc(n - 1) + calc(n - 2);
            }
        }.calc;
        break :blk fib;
    };
    
    // Calculate Fibonacci at compile time
    const fib_10 = comptime fibonacci(10);
    print("Fibonacci(10) computed at compile-time: {}\n", .{fib_10});
    
    const factorial = comptime blk: {
        const fact = struct {
            fn calc(n: comptime_int) comptime_int {
                if (n <= 1) return 1;
                return n * calc(n - 1);
            }
        }.calc;
        break :blk fact;
    };
    
    const fact_8 = comptime factorial(8);
    print("8! computed at compile-time: {}\n", .{fact_8});
}

pub fn demonstrateGenericTypes() void {
    print("\n=== Generic Types and Functions ===\n");
    
    // Generic array sum function
    const ArraySum = struct {
        fn sum(comptime T: type, arr: []const T) T {
            var total: T = 0;
            for (arr) |item| {
                total += item;
            }
            return total;
        }
    };
    
    const int_array = [_]i32{ 1, 2, 3, 4, 5 };
    const float_array = [_]f32{ 1.5, 2.5, 3.5, 4.5, 5.5 };
    
    print("Sum of integers: {}\n", .{ArraySum.sum(i32, &int_array)});
    print("Sum of floats: {d:.1}\n", .{ArraySum.sum(f32, &float_array)});
    
    // Simple generic data structure
    const SimpleStack = struct {
        fn StackType(comptime T: type, comptime max_size: usize) type {
            return struct {
                items: [max_size]T = undefined,
                count: usize = 0,
                
                const Self = @This();
                
                pub fn push(self: *Self, item: T) !void {
                    if (self.count >= max_size) return error.StackOverflow;
                    self.items[self.count] = item;
                    self.count += 1;
                }
                
                pub fn pop(self: *Self) ?T {
                    if (self.count == 0) return null;
                    self.count -= 1;
                    return self.items[self.count];
                }
            };
        }
    };
    
    var int_stack = SimpleStack.StackType(i32, 5){};
    try int_stack.push(10);
    try int_stack.push(20);
    try int_stack.push(30);
    
    print("Popped from int stack: {?}, {?}\n", .{ int_stack.pop(), int_stack.pop() });
}

pub fn demonstrateTypeIntrospection() void {
    print("\n=== Type Introspection ===\n");
    
    const Point = struct {
        x: f32,
        y: f32,
        z: f32 = 0.0,
    };
    
    // Get type information at compile time
    const type_info = @typeInfo(Point);
    print("Point struct has {} fields:\n", .{type_info.Struct.fields.len});
    
    inline for (type_info.Struct.fields) |field| {
        print("  Field '{s}': {any}\n", .{ field.name, field.type });
    }
    
    // Check if type has specific field
    const HasField = struct {
        fn check(comptime T: type, comptime field_name: []const u8) bool {
            const info = @typeInfo(T);
            if (info != .Struct) return false;
            
            inline for (info.Struct.fields) |field| {
                if (std.mem.eql(u8, field.name, field_name)) {
                    return true;
                }
            }
            return false;
        }
    };
    
    print("Point has 'x' field: {}\n", .{HasField.check(Point, "x")});
    print("Point has 'w' field: {}\n", .{HasField.check(Point, "w")});
}

pub fn demonstrateComptimeArrays() void {
    print("\n=== Compile-time Array Generation ===\n");
    
    // Generate multiplication table at compile time
    const table = comptime blk: {
        const size = 5;
        var result: [size][size]u32 = undefined;
        for (&result, 0..) |*row, i| {
            for (row, 0..) |*cell, j| {
                cell.* = @intCast((i + 1) * (j + 1));
            }
        }
        break :blk result;
    };
    
    print("5x5 multiplication table (compile-time generated):\n");
    for (table, 0..) |row, i| {
        print("Row {}: {any}\n", .{ i + 1, row });
    }
    
    // Generate powers of 2 at compile time
    const powersOf2 = comptime blk: {
        var powers: [10]u32 = undefined;
        for (&powers, 0..) |*power, i| {
            power.* = @as(u32, 1) << @intCast(i);
        }
        break :blk powers;
    };
    
    print("Powers of 2: {any}\n", .{powersOf2});
}

pub fn demonstrateComptimeSwitch() void {
    print("\n=== Compile-time Switch ===\n");
    
    const TypeProcessor = struct {
        fn process(comptime T: type, value: T) void {
            switch (@typeInfo(T)) {
                .Int => |int_info| {
                    print("Integer value: {} (bits: {})\n", .{ value, int_info.bits });
                },
                .Float => |float_info| {
                    print("Float value: {d:.2} (bits: {})\n", .{ value, float_info.bits });
                },
                .Bool => {
                    print("Boolean value: {}\n", .{value});
                },
                .Pointer => |ptr_info| {
                    print("Pointer to {any}: {*}\n", .{ ptr_info.child, value });
                },
                else => {
                    print("Other type: {any}\n", .{@TypeOf(value)});
                },
            }
        }
    };
    
    TypeProcessor.process(i32, 42);
    TypeProcessor.process(f64, 3.14159);
    TypeProcessor.process(bool, true);
    
    var number: i32 = 100;
    TypeProcessor.process(*i32, &number);
}

test "compile-time examples" {
    demonstrateComptimeBasics();
    demonstrateComptimeFunctions();
    demonstrateGenericTypes();
    demonstrateTypeIntrospection();
    demonstrateComptimeArrays();
    demonstrateComptimeSwitch();
}