const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

pub fn demonstrateStringBasics() void {
    print("=== String Basics ===\n");
    
    // String literals
    const hello = "Hello, World!";
    const multiline =
        \\This is a multiline string
        \\It can span multiple lines
        \\Without escape sequences!
    ;
    
    print("String: {s}\n", .{hello});
    print("Length: {}\n", .{hello.len});
    print("Multiline:\n{s}\n\n", .{multiline});
}

pub fn demonstrateStringFormatting(allocator: std.mem.Allocator) !void {
    print("=== String Formatting ===\n");
    
    const name = "Anubhav";
    const age = 25;
    const pi = 3.14159;
    
    // Format to buffer
    var buffer: [100]u8 = undefined;
    const formatted = try std.fmt.bufPrint(buffer[0..], "Name: {s}, Age: {}, Pi: {d:.2}", .{ name, age, pi });
    print("Formatted: {s}\n", .{formatted});
    
    // Allocate formatted string
    const allocated_string = try std.fmt.allocPrint(allocator, "Hello {s}! You are {} years old.", .{ name, age });
    defer allocator.free(allocated_string);
    print("Allocated: {s}\n", .{allocated_string});
}

pub fn demonstrateStringOperations(_: std.mem.Allocator) !void {
    print("\n=== String Operations ===\n");
    
    const text = "Hello,Zig,Programming,Language";
    
    // Split string
    var split_iterator = std.mem.split(u8, text, ",");
    print("Split by comma:\n");
    while (split_iterator.next()) |part| {
        print("  '{s}'\n", .{part});
    }
    
    // String comparison
    const str1 = "apple";
    const str2 = "banana";
    const str3 = "apple";
    
    print("\nString comparisons:\n");
    print("'{s}' == '{s}': {}\n", .{ str1, str2, std.mem.eql(u8, str1, str2) });
    print("'{s}' == '{s}': {}\n", .{ str1, str3, std.mem.eql(u8, str1, str3) });
    
    // String contains
    const haystack = "The quick brown fox jumps";
    const needle = "brown";
    print("'{s}' contains '{s}': {}\n", .{ haystack, needle, std.mem.indexOf(u8, haystack, needle) != null });
    
    // Case operations
    var lowercase_buffer: [50]u8 = undefined;
    const uppercase = "HELLO WORLD";
    const lowercase = std.ascii.lowerString(lowercase_buffer[0..], uppercase);
    print("Uppercase: '{s}' -> Lowercase: '{s}'\n", .{ uppercase, lowercase });
}

pub fn demonstrateStringBuilder(allocator: std.mem.Allocator) !void {
    print("\n=== String Builder (ArrayList) ===\n");
    
    var string_builder = ArrayList(u8).init(allocator);
    defer string_builder.deinit();
    
    try string_builder.appendSlice("Building ");
    try string_builder.appendSlice("a ");
    try string_builder.appendSlice("string ");
    try string_builder.appendSlice("dynamically!");
    
    print("Built string: {s}\n", .{string_builder.items});
    
    // Writer interface
    const writer = string_builder.writer();
    try writer.print(" Added number: {}", .{42});
    
    print("After writer: {s}\n", .{string_builder.items});
}

pub fn demonstrateUnicodeStrings() !void {
    print("\n=== Unicode Strings ===\n");
    
    const unicode_text = "Hello 🦎 Zig! 🚀 नमस्ते";
    print("Unicode string: {s}\n", .{unicode_text});
    print("Byte length: {}\n", .{unicode_text.len});
    
    // Count Unicode code points
    const unicode_len = try std.unicode.utf8CountCodepoints(unicode_text);
    print("Unicode length: {}\n", .{unicode_len});
    
    // Iterate over code points
    print("Code points: ");
    var iterator = (try std.unicode.Utf8View.init(unicode_text)).iterator();
    while (iterator.nextCodepoint()) |codepoint| {
        print("U+{X} ", .{codepoint});
    }
    print("\n");
}

test "string operations" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    demonstrateStringBasics();
    try demonstrateStringFormatting(allocator);
    try demonstrateStringOperations(allocator);
    try demonstrateStringBuilder(allocator);
    try demonstrateUnicodeStrings();
}