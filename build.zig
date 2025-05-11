const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const dependecies = [_][]const u8{"httpz"};
    for (dependecies) |dependency_name| {
        const dependency = b.dependency(dependency_name, .{
            .target = target,
            .optimize = optimize,
        });
        module.addImport(dependency_name, dependency.module(dependency_name));
    }

    const main = b.addExecutable(.{
        .name = "main",
        .root_module = module,
    });
    b.installArtifact(main);
}
