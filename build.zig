const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Build
    const exe = b.addExecutable(.{
        .name = "helloworld",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Link with the standard libcpp
    exe.linkLibCpp();
    exe.addIncludePath(.{ .path = "include" });
    exe.addCSourceFile(std.Build.Module.CSourceFile{
        .file = .{ .path = "include/hello.cpp" },
    });

    b.installArtifact(exe);

    // Run
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Unit tests
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
        // .link_libcpp = true,
    });

    unit_tests.linkLibCpp();
    unit_tests.addIncludePath(.{ .path = "include" });
    unit_tests.addCSourceFile(std.Build.Module.CSourceFile{
        .file = .{ .path = "include/hello.cpp" },
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
