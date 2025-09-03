const std = @import("std");
const print = std.debug.print;

pub fn demonstrateFileOperations(allocator: std.mem.Allocator) !void {
    print("=== File I/O Examples ===\n", .{});
    
    const filename = "test_file.txt";
    const content = "Hello from Zig!\nThis is a test file.\nLearning file I/O operations.";
    
    // Write to file
    {
        const file = try std.fs.cwd().createFile(filename, .{});
        defer file.close();
        
        try file.writeAll(content);
        print("Written to file: {s}\n", .{filename});
    }
    
    // Read entire file
    {
        const file_content = try std.fs.cwd().readFileAlloc(allocator, filename, 1024);
        defer allocator.free(file_content);
        
        print("File content:\n{s}\n", .{file_content});
    }
    
    // Read file line by line (simplified)
    {
        const file_content2 = try std.fs.cwd().readFileAlloc(allocator, filename, 1024);
        defer allocator.free(file_content2);
        
        print("\nReading as lines:\n", .{});
        var line_iter = std.mem.splitSequence(u8, file_content2, "\n");
        var line_number: u32 = 1;
        while (line_iter.next()) |line| {
            print("{}: {s}\n", .{ line_number, line });
            line_number += 1;
        }
    }
    
    // Append to file
    {
        const file = try std.fs.cwd().openFile(filename, .{ .mode = .write_only });
        defer file.close();
        
        try file.seekFromEnd(0);
        try file.writeAll("\nAppended line from Zig!");
        print("\nAppended to file\n", .{});
    }
    
    // Clean up
    try std.fs.cwd().deleteFile(filename);
    print("Cleaned up test file\n", .{});
}

pub fn demonstrateDirectoryOperations() !void {
    print("\n=== Directory Operations ===\n", .{});
    
    const test_dir = "test_directory";
    
    // Create directory
    try std.fs.cwd().makeDir(test_dir);
    print("Created directory: {s}\n", .{test_dir});
    
    // Create files in directory
    const file_names = [_][]const u8{ "file1.txt", "file2.txt", "file3.txt" };
    
    for (file_names) |file_name| {
        var path_buffer: [256]u8 = undefined;
        const full_path = try std.fmt.bufPrint(path_buffer[0..], "{s}/{s}", .{ test_dir, file_name });
        
        const file = try std.fs.cwd().createFile(full_path, .{});
        defer file.close();
        
        try file.writeAll("Test content");
    }
    print("Created {} files in directory\n", .{file_names.len});
    
    // List directory contents
    var dir = try std.fs.cwd().openDir(test_dir, .{ .iterate = true });
    defer dir.close();
    
    var iterator = dir.iterate();
    print("Directory contents:\n", .{});
    while (try iterator.next()) |entry| {
        const type_str = switch (entry.kind) {
            .file => "FILE",
            .directory => "DIR",
            else => "OTHER",
        };
        print("  {s}: {s}\n", .{ type_str, entry.name });
    }
    
    // Clean up
    for (file_names) |file_name| {
        var path_buffer: [256]u8 = undefined;
        const full_path = try std.fmt.bufPrint(path_buffer[0..], "{s}/{s}", .{ test_dir, file_name });
        try std.fs.cwd().deleteFile(full_path);
    }
    try std.fs.cwd().deleteDir(test_dir);
    print("Cleaned up test directory\n", .{});
}

pub fn demonstrateFileStreams(allocator: std.mem.Allocator) !void {
    print("\n=== File Streams and Buffering ===\n", .{});
    
    const filename = "stream_test.txt";
    
    // Write multiple lines
    {
        const file = try std.fs.cwd().createFile(filename, .{});
        defer file.close();
        
        const content_to_write = "Line 0: Hello from writer!\nLine 1: Hello from writer!\nLine 2: Hello from writer!\nLine 3: Hello from writer!\nLine 4: Hello from writer!\n";
        try file.writeAll(content_to_write);
        
        print("Written multiple lines using writeAll\n", .{});
    }
    
    // Read with different methods
    {
        const file = try std.fs.cwd().openFile(filename, .{});
        defer file.close();
        
        // Get file size
        const file_size = try file.getEndPos();
        print("File size: {} bytes\n", .{file_size});
        
        // Read with seek
        try file.seekTo(0);
        var buffer: [100]u8 = undefined;
        const bytes_read = try file.readAll(buffer[0..]);
        print("First {} bytes: {s}\n", .{ bytes_read, buffer[0..bytes_read] });
    }
    
    // JSON-like structured data
    const Person = struct {
        name: []const u8,
        age: u32,
        city: []const u8,
    };
    
    const person = Person{
        .name = "Anubhav",
        .age = 25,
        .city = "Delhi",
    };
    _ = person; // Suppress unused variable warning
    
    // Write JSON (simple string)
    {
        const json_file = try std.fs.cwd().createFile("person.json", .{});
        defer json_file.close();
        
        const json_string = "{\"name\":\"Anubhav\",\"age\":25,\"city\":\"Delhi\"}";
        try json_file.writeAll(json_string);
        print("Written JSON data to person.json\n", .{});
    }
    
    // Read and parse JSON
    {
        const json_content = try std.fs.cwd().readFileAlloc(allocator, "person.json", 1024);
        defer allocator.free(json_content);
        
        print("JSON content: {s}\n", .{json_content});
    }
    
    // Clean up
    try std.fs.cwd().deleteFile(filename);
    try std.fs.cwd().deleteFile("person.json");
    print("Cleaned up stream test files\n", .{});
}

test "file I/O operations" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    try demonstrateFileOperations(allocator);
    try demonstrateDirectoryOperations();
    try demonstrateFileStreams(allocator);
}