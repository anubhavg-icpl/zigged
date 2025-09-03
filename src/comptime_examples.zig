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
    
    const fibonacci = struct {
        fn fib(n: comptime_int) comptime_int {
            if (n <= 1) return n;
            return fib(n - 1) + fib(n - 2);
        }
    }.fib;
    
    // Calculate Fibonacci at compile time
    const fib_10 = comptime fibonacci(10);
    print("Fibonacci(10) computed at compile-time: {}\n", .{fib_10});
    
    const factorial = struct {
        fn fact(n: comptime_int) comptime_int {
            if (n <= 1) return 1;
            return n * fact(n - 1);
        }
    }.fact;
    
    const fact_8 = comptime factorial(8);
    print("8! computed at compile-time: {}\n", .{fact_8});
    
    // Compile-time prime checking
    const isPrime = struct {
        fn check(n: comptime_int) bool {
            if (n < 2) return false;
            if (n == 2) return true;
            if (n % 2 == 0) return false;
            
            var i = 3;
            while (i * i <= n) : (i += 2) {
                if (n % i == 0) return false;
            }
            return true;
        }
    }.check;
    
    const prime_check = comptime isPrime(97);
    print("Is 97 prime? (compile-time): {}\n", .{prime_check});
}

pub fn demonstrateGenericTypes() void {
    print("\n=== Generic Types and Functions ===\n");
    
    // Generic array function
    fn arraySum(comptime T: type, arr: []const T) T {
        var sum: T = 0;
        for (arr) |item| {
            sum += item;
        }
        return sum;
    }
    
    const int_array = [_]i32{ 1, 2, 3, 4, 5 };
    const float_array = [_]f32{ 1.5, 2.5, 3.5, 4.5, 5.5 };
    
    print("Sum of integers: {}\n", .{arraySum(i32, &int_array)});
    print("Sum of floats: {d:.1}\n", .{arraySum(f32, &float_array)});
    
    // Generic stack
    fn Stack(comptime T: type, comptime max_size: usize) type {
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
            
            pub fn isEmpty(self: Self) bool {
                return self.count == 0;
            }
            
            pub fn isFull(self: Self) bool {
                return self.count >= max_size;
            }
        };
    }
    
    var int_stack = Stack(i32, 5){};
    try int_stack.push(10);
    try int_stack.push(20);
    try int_stack.push(30);
    
    print("Popped from int stack: {?}, {?}\n", .{ int_stack.pop(), int_stack.pop() });
    
    var string_stack = Stack([]const u8, 3){};
    try string_stack.push("first");
    try string_stack.push("second");
    
    print("Popped from string stack: {?s}\n", .{string_stack.pop()});
}

pub fn demonstrateTypeIntrospection() void {
    print("\n=== Type Introspection ===\n");
    
    const Point = struct {
        x: f32,
        y: f32,
        z: f32 = 0.0,
        
        pub fn distance(self: @This()) f32 {
            return @sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
        }
    };
    
    // Get type information at compile time
    const type_info = @typeInfo(Point);
    print("Point struct has {} fields:\n", .{type_info.Struct.fields.len});
    
    inline for (type_info.Struct.fields) |field| {
        print("  Field '{s}': {any}\n", .{ field.name, field.type });
    }
    
    // Check if type has specific field
    const hasField = struct {
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
    }.check;
    
    print("Point has 'x' field: {}\n", .{hasField(Point, "x")});
    print("Point has 'w' field: {}\n", .{hasField(Point, "w")});
    
    // Generic field access
    fn getField(value: anytype, comptime field_name: []const u8) @TypeOf(@field(value, field_name)) {
        return @field(value, field_name);
    }
    
    const point = Point{ .x = 3.0, .y = 4.0, .z = 5.0 };
    print("Point.x via generic access: {d:.1}\n", .{getField(point, "x")});
}

pub fn demonstrateComptimeArrays() void {
    print("\n=== Compile-time Array Generation ===\n");
    
    // Generate multiplication table at compile time
    const multiplicationTable = struct {
        fn generate(comptime size: usize) [size][size]u32 {
            var table: [size][size]u32 = undefined;
            for (&table, 0..) |*row, i| {
                for (row, 0..) |*cell, j| {
                    cell.* = @intCast((i + 1) * (j + 1));
                }
            }
            return table;
        }
    }.generate;
    
    const table = comptime multiplicationTable(5);
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
    
    fn processValue(comptime T: type, value: T) void {
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
    
    processValue(i32, 42);
    processValue(f64, 3.14159);
    processValue(bool, true);
    
    var number: i32 = 100;
    processValue(*i32, &number);
}

test "compile-time examples" {
    demonstrateComptimeBasics();
    demonstrateComptimeFunctions();
    demonstrateGenericTypes();
    demonstrateTypeIntrospection();
    demonstrateComptimeArrays();
    demonstrateComptimeSwitch();
}