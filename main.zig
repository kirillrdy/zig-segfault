const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var server = try httpz.Server(void).init(allocator, .{ .port = 3000 }, {});
    var router = try server.router(.{});
    router.get("/", makeHandler("home", home), .{});
}

fn makeHandler(_: []const u8, func: fn (comptime []const u8, anytype) anyerror!void) fn (*httpz.Request, *httpz.Response) anyerror!void {
    return struct {
        fn handler(_: *httpz.Request, _: *httpz.Response) !void {
            try func("", "");
        }
    }.handler;
}

fn home(comptime _: []const u8, _: anytype) !void {}
