const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const AutoHashMap = std.AutoHashMap;

pub fn demonstrateArrays() void {
    print("=== Arrays and Slices ===\n", .{});
    
    // Fixed-size arrays
    const fixed_array = [5]i32{ 1, 2, 3, 4, 5 };
    print("Fixed array: {any}\n", .{fixed_array});
    
    // Array initialization patterns
    const zeros = [_]i32{0} ** 10;
    print("10 zeros: {any}\n", .{zeros[0..5]}); // Show first 5
    
    // Multi-dimensional arrays
    const matrix = [3][3]i32{
        [_]i32{ 1, 2, 3 },
        [_]i32{ 4, 5, 6 },
        [_]i32{ 7, 8, 9 },
    };
    
    print("Matrix:\n", .{});
    for (matrix) |row| {
        print("  {any}\n", .{row});
    }
    
    // Array operations
    var mutable_array = [_]i32{ 10, 20, 30, 40, 50 };
    mutable_array[2] = 99;
    print("Modified array: {any}\n", .{mutable_array});
}

pub fn demonstrateArrayList(allocator: std.mem.Allocator) !void {
    print("\n=== Dynamic Arrays (ArrayList) ===\n", .{});
    
    var numbers = ArrayList(i32){};
    defer numbers.deinit(allocator);
    
    // Add elements
    try numbers.append(allocator, 10);
    try numbers.append(allocator, 20);
    try numbers.appendSlice(allocator, &[_]i32{ 30, 40, 50 });
    
    print("ArrayList: {any}\n", .{numbers.items});
    print("Length: {}, Capacity: {}\n", .{ numbers.items.len, numbers.capacity });
    
    // Insert and remove
    try numbers.insert(allocator, 2, 25);
    print("After insert at index 2: {any}\n", .{numbers.items});
    
    const removed = numbers.orderedRemove(1);
    print("Removed {}, remaining: {any}\n", .{ removed, numbers.items });
    
    // Pop and resize
    const last = numbers.pop();
    print("Popped: {}, remaining: {any}\n", .{ last, numbers.items });
    
    try numbers.resize(allocator, 10);
    print("Resized to 10 (filled with undefined): length = {}\n", .{numbers.items.len});
}

pub fn demonstrateHashMaps(allocator: std.mem.Allocator) !void {
    print("\n=== Hash Maps ===\n", .{});
    
    // String to integer map
    var word_count = AutoHashMap([]const u8, i32).init(allocator);
    defer word_count.deinit();
    
    const words = [_][]const u8{ "hello", "world", "zig", "hello", "programming", "zig", "hello" };
    
    // Count word occurrences
    for (words) |word| {
        const result = try word_count.getOrPut(word);
        if (result.found_existing) {
            result.value_ptr.* += 1;
        } else {
            result.value_ptr.* = 1;
        }
    }
    
    print("Word counts:\n", .{});
    var iterator = word_count.iterator();
    while (iterator.next()) |entry| {
        print("  '{s}': {}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
    
    // Custom struct as key
    const Point = struct {
        x: i32,
        y: i32,
        
        pub fn hash(self: @This()) u64 {
            const hasher = std.hash_map.getAutoHashFn(@This(), void){};
            return hasher(self, {});
        }
        
        pub fn eql(a: @This(), b: @This()) bool {
            return a.x == b.x and a.y == b.y;
        }
    };
    
    var point_map = HashMap(Point, []const u8, Point, std.hash_map.default_max_load_percentage).init(allocator);
    defer point_map.deinit();
    
    try point_map.put(Point{ .x = 0, .y = 0 }, "origin");
    try point_map.put(Point{ .x = 1, .y = 1 }, "diagonal");
    try point_map.put(Point{ .x = -1, .y = 0 }, "left");
    
    print("\nPoint map:\n", .{});
    var point_iterator = point_map.iterator();
    while (point_iterator.next()) |entry| {
        print("  ({}, {}): {s}\n", .{ entry.key_ptr.x, entry.key_ptr.y, entry.value_ptr.* });
    }
}

pub fn demonstrateLinkedList(allocator: std.mem.Allocator) !void {
    print("\n=== Linked Lists ===\n", .{});
    
    const Node = struct {
        data: i32,
        next: ?*@This() = null,
    };
    
    // Create nodes
    var node1 = Node{ .data = 10 };
    var node2 = Node{ .data = 20 };
    var node3 = Node{ .data = 30 };
    
    // Link nodes
    node1.next = &node2;
    node2.next = &node3;
    
    // Traverse and print
    print("Linked list: ", .{});
    var current: ?*Node = &node1;
    while (current) |node| {
        print("{} ", .{node.data});
        current = node.next;
    }
    print("\n", .{});
    
    // Using std.SinglyLinkedList
    const SLL = std.SinglyLinkedList(i32);
    var sll = SLL{};
    
    const nodes = try allocator.alloc(SLL.Node, 5);
    defer allocator.free(nodes);
    
    for (nodes, 0..) |*node, i| {
        node.data = @intCast((i + 1) * 10);
        sll.prepend(node);
    }
    
    print("SinglyLinkedList: ", .{});
    var sll_current = sll.first;
    while (sll_current) |node| {
        print("{} ", .{node.data});
        sll_current = node.next;
    }
    print("\n", .{});
}

pub fn demonstrateQueue(allocator: std.mem.Allocator) !void {
    print("\n=== Queue Implementation ===\n", .{});
    
    const Queue = struct {
        items: ArrayList(i32),
        head: usize = 0,
        
        const Self = @This();
        
        pub fn init(alloc: std.mem.Allocator) Self {
            _ = alloc;
            return Self{ .items = ArrayList(i32){} };
        }
        
        pub fn deinit(self: *Self, alloc: std.mem.Allocator) void {
            self.items.deinit(alloc);
        }
        
        pub fn enqueue(self: *Self, alloc: std.mem.Allocator, item: i32) !void {
            try self.items.append(alloc, item);
        }
        
        pub fn dequeue(self: *Self) ?i32 {
            if (self.head >= self.items.items.len) return null;
            const item = self.items.items[self.head];
            self.head += 1;
            
            // Compact when half empty
            if (self.head > self.items.items.len / 2) {
                const remaining = self.items.items[self.head..];
                std.mem.copyForwards(i32, self.items.items, remaining);
                self.items.items.len = remaining.len;
                self.head = 0;
            }
            
            return item;
        }
        
        pub fn peek(self: *Self) ?i32 {
            if (self.head >= self.items.items.len) return null;
            return self.items.items[self.head];
        }
        
        pub fn isEmpty(self: *Self) bool {
            return self.head >= self.items.items.len;
        }
    };
    
    var queue = Queue.init(allocator);
    defer queue.deinit(allocator);
    
    // Enqueue items
    try queue.enqueue(allocator, 1);
    try queue.enqueue(allocator, 2);
    try queue.enqueue(allocator, 3);
    try queue.enqueue(allocator, 4);
    try queue.enqueue(allocator, 5);
    
    print("Queue operations:\n", .{});
    print("Peek: {?}\n", .{queue.peek()});
    
    // Dequeue items
    while (!queue.isEmpty()) {
        print("Dequeued: {?}\n", .{queue.dequeue()});
    }
}

pub fn demonstrateStack(allocator: std.mem.Allocator) !void {
    print("\n=== Stack Implementation ===\n", .{});
    
    var stack = ArrayList([]const u8){};
    defer stack.deinit(allocator);
    
    // Push items
    try stack.append(allocator, "first");
    try stack.append(allocator, "second");
    try stack.append(allocator, "third");
    
    print("Stack: {s}\n", .{stack.items});
    
    // Pop items (LIFO)
    while (stack.items.len > 0) {
        const item = stack.pop();
        print("Popped: {s}, remaining: {s}\n", .{ item, stack.items });
    }
}

test "data structures examples" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    demonstrateArrays();
    try demonstrateArrayList(allocator);
    try demonstrateHashMaps(allocator);
    try demonstrateLinkedList(allocator);
    try demonstrateQueue(allocator);
    try demonstrateStack(allocator);
}