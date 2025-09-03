const std = @import("std");
const print = std.debug.print;
const Thread = std.Thread;
const Mutex = std.Thread.Mutex;
const Condition = std.Thread.Condition;
const Atomic = std.atomic.Value;

pub fn demonstrateBasicThreads(allocator: std.mem.Allocator) !void {
    print("=== Basic Threading ===\n");
    
    const WorkerData = struct {
        id: u32,
        iterations: u32,
    };
    
    const worker_function = struct {
        fn run(data: WorkerData) void {
            for (0..data.iterations) |i| {
                print("Worker {}: iteration {}\n", .{ data.id, i });
                std.time.sleep(100 * std.time.ns_per_ms); // 100ms
            }
            print("Worker {} completed\n", .{data.id});
        }
    }.run;
    
    // Create multiple threads
    const thread_count = 3;
    var threads = try allocator.alloc(Thread, thread_count);
    defer allocator.free(threads);
    
    // Start threads
    for (threads, 0..) |*thread, i| {
        const data = WorkerData{ .id = @intCast(i + 1), .iterations = 3 };
        thread.* = try Thread.spawn(.{}, worker_function, .{data});
    }
    
    // Wait for threads to complete
    for (threads) |thread| {
        thread.join();
    }
    
    print("All threads completed\n\n");
}

pub fn demonstrateMutex(allocator: std.mem.Allocator) !void {
    print("=== Mutex and Shared State ===\n");
    
    const SharedCounter = struct {
        mutex: Mutex = .{},
        value: i32 = 0,
        
        const Self = @This();
        
        pub fn increment(self: *Self, amount: i32, worker_id: u32) void {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            const old_value = self.value;
            std.time.sleep(50 * std.time.ns_per_ms); // Simulate work
            self.value += amount;
            
            print("Worker {}: {} + {} = {}\n", .{ worker_id, old_value, amount, self.value });
        }
        
        pub fn get(self: *Self) i32 {
            self.mutex.lock();
            defer self.mutex.unlock();
            return self.value;
        }
    };
    
    var counter = SharedCounter{};
    
    const counter_worker = struct {
        fn run(shared_counter: *SharedCounter, worker_id: u32, increments: u32) void {
            for (0..increments) |_| {
                shared_counter.increment(1, worker_id);
            }
        }
    }.run;
    
    const thread_count = 3;
    var threads = try allocator.alloc(Thread, thread_count);
    defer allocator.free(threads);
    
    // Start threads that increment counter
    for (threads, 0..) |*thread, i| {
        thread.* = try Thread.spawn(.{}, counter_worker, .{ &counter, @intCast(i + 1), 5 });
    }
    
    // Wait for all threads
    for (threads) |thread| {
        thread.join();
    }
    
    print("Final counter value: {}\n\n", .{counter.get()});
}

pub fn demonstrateAtomics() !void {
    print("=== Atomic Operations ===\n");
    
    var atomic_counter = Atomic(u32).init(0);
    var done = Atomic(bool).init(false);
    
    const atomic_worker = struct {
        fn run(counter: *Atomic(u32), finished: *Atomic(bool), worker_id: u32) void {
            for (0..1000) |_| {
                _ = counter.fetchAdd(1, .acq_rel);
            }
            print("Atomic worker {} completed 1000 increments\n", .{worker_id});
            
            // Check if this is the last worker to finish
            const prev_count = counter.load(.acquire);
            if (prev_count >= 3000) { // 3 workers * 1000 each
                finished.store(true, .release);
            }
        }
    }.run;
    
    // Create threads for atomic operations
    var thread1 = try Thread.spawn(.{}, atomic_worker, .{ &atomic_counter, &done, 1 });
    var thread2 = try Thread.spawn(.{}, atomic_worker, .{ &atomic_counter, &done, 2 });
    var thread3 = try Thread.spawn(.{}, atomic_worker, .{ &atomic_counter, &done, 3 });
    
    // Monitor progress
    while (!done.load(.acquire)) {
        const current = atomic_counter.load(.acquire);
        print("Current atomic counter: {}\n", .{current});
        std.time.sleep(200 * std.time.ns_per_ms);
    }
    
    thread1.join();
    thread2.join();
    thread3.join();
    
    print("Final atomic counter: {}\n\n", .{atomic_counter.load(.acquire)});
}

pub fn demonstrateProducerConsumer(allocator: std.mem.Allocator) !void {
    print("=== Producer-Consumer Pattern ===\n");
    
    const Buffer = struct {
        mutex: Mutex = .{},
        condition: Condition = .{},
        data: std.ArrayList(i32),
        max_size: usize,
        finished: bool = false,
        
        const Self = @This();
        
        pub fn init(alloc: std.mem.Allocator, size: usize) Self {
            return Self{
                .data = std.ArrayList(i32).init(alloc),
                .max_size = size,
            };
        }
        
        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }
        
        pub fn produce(self: *Self, item: i32) !void {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            // Wait for space
            while (self.data.items.len >= self.max_size) {
                self.condition.wait(&self.mutex);
            }
            
            try self.data.append(item);
            print("Produced: {} (buffer size: {})\n", .{ item, self.data.items.len });
            
            self.condition.signal();
        }
        
        pub fn consume(self: *Self) ?i32 {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            // Wait for data or finish signal
            while (self.data.items.len == 0 and !self.finished) {
                self.condition.wait(&self.mutex);
            }
            
            if (self.data.items.len == 0 and self.finished) {
                return null;
            }
            
            const item = self.data.orderedRemove(0);
            print("Consumed: {} (buffer size: {})\n", .{ item, self.data.items.len });
            
            self.condition.signal();
            return item;
        }
        
        pub fn finish(self: *Self) void {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            self.finished = true;
            self.condition.broadcast();
        }
    };
    
    var buffer = Buffer.init(allocator, 5);
    defer buffer.deinit();
    
    const producer = struct {
        fn run(buf: *Buffer) !void {
            for (1..11) |i| {
                try buf.produce(@intCast(i));
                std.time.sleep(100 * std.time.ns_per_ms);
            }
            buf.finish();
            print("Producer finished\n");
        }
    }.run;
    
    const consumer = struct {
        fn run(buf: *Buffer, consumer_id: u32) void {
            while (buf.consume()) |item| {
                print("Consumer {}: got {}\n", .{ consumer_id, item });
                std.time.sleep(150 * std.time.ns_per_ms);
            }
            print("Consumer {} finished\n", .{consumer_id});
        }
    }.run;
    
    // Start producer and consumers
    var producer_thread = try Thread.spawn(.{}, producer, .{&buffer});
    var consumer1_thread = try Thread.spawn(.{}, consumer, .{ &buffer, 1 });
    var consumer2_thread = try Thread.spawn(.{}, consumer, .{ &buffer, 2 });
    
    producer_thread.join();
    consumer1_thread.join();
    consumer2_thread.join();
    
    print("Producer-Consumer example completed\n\n");
}

pub fn demonstrateChannels(allocator: std.mem.Allocator) !void {
    print("=== Channel-like Communication ===\n");
    
    const Channel = struct {
        mutex: Mutex = .{},
        condition: Condition = .{},
        queue: std.ArrayList([]const u8),
        closed: bool = false,
        
        const Self = @This();
        
        pub fn init(alloc: std.mem.Allocator) Self {
            return Self{ .queue = std.ArrayList([]const u8).init(alloc) };
        }
        
        pub fn deinit(self: *Self) void {
            self.queue.deinit();
        }
        
        pub fn send(self: *Self, message: []const u8) !void {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            if (self.closed) return;
            
            try self.queue.append(message);
            self.condition.signal();
        }
        
        pub fn receive(self: *Self) ?[]const u8 {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            while (self.queue.items.len == 0 and !self.closed) {
                self.condition.wait(&self.mutex);
            }
            
            if (self.queue.items.len == 0) return null;
            
            return self.queue.orderedRemove(0);
        }
        
        pub fn close(self: *Self) void {
            self.mutex.lock();
            defer self.mutex.unlock();
            
            self.closed = true;
            self.condition.broadcast();
        }
    };
    
    var channel = Channel.init(allocator);
    defer channel.deinit();
    
    const sender = struct {
        fn run(ch: *Channel) !void {
            const messages = [_][]const u8{ "Hello", "from", "Zig", "threads!" };
            
            for (messages) |msg| {
                try ch.send(msg);
                print("Sent: {s}\n", .{msg});
                std.time.sleep(100 * std.time.ns_per_ms);
            }
            
            ch.close();
            print("Channel closed\n");
        }
    }.run;
    
    const receiver = struct {
        fn run(ch: *Channel) void {
            while (ch.receive()) |message| {
                print("Received: {s}\n", .{message});
                std.time.sleep(50 * std.time.ns_per_ms);
            }
            print("Receiver finished\n");
        }
    }.run;
    
    var sender_thread = try Thread.spawn(.{}, sender, .{&channel});
    var receiver_thread = try Thread.spawn(.{}, receiver, .{&channel});
    
    sender_thread.join();
    receiver_thread.join();
    
    print("Channel example completed\n");
}

test "concurrency examples" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    try demonstrateBasicThreads(allocator);
    try demonstrateMutex(allocator);
    try demonstrateAtomics();
    try demonstrateProducerConsumer(allocator);
    try demonstrateChannels(allocator);
}