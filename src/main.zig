const std = @import("std");

const stdout = std.io.getStdOut().writer();

fn read_entire_file(allocator: std.mem.Allocator, filename: *const [11:0]u8) ![]u8 {
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath(filename, &path_buffer);

    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    const max_bytes = 10_000;
    const file_contents: []u8 = try file.readToEndAlloc(allocator, max_bytes);
    return file_contents;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    //const filename = "example.tiq";
    //var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    //const path = try std.fs.realpath(filename, &path_buffer);

    //const file = try std.fs.openFileAbsolute(path, .{});
    //defer file.close();

    //const max_bytes = 10_000;
    //const file_contents: []u8 = try file.readToEndAlloc(allocator, max_bytes);
    const file_contents = read_entire_file(allocator, "example.tiq");
    if (file_contents) |fc| {
        try stdout.print("{s}", .{fc});
    } else |err| {
        try stdout.print("{s}", .{err});
    }
}
