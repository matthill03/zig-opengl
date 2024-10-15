const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-glew-glfw-example",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Paths to your custom-built GLFW and GLEW
    const glfw_path = "libs/glfw"; // Adjust this to your GLFW build directory
    const glew_path = "libs/glew"; // Adjust this to your GLEW build directory

    // Link GLFW
    exe.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ glfw_path, "build", "src " }) });
    exe.linkSystemLibrary("glfw3");

    // Link GLEW
    exe.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ glew_path, "lib " }) });
    exe.linkSystemLibrary("GLEW");

    // Add include directories
    exe.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ glfw_path, "include " }) });
    exe.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ glew_path, "include " }) });

    // Link other necessary system libraries
    exe.linkSystemLibrary("GL");
    // if (target.isWindows()) {
    //     exe.linkSystemLibrary("gdi32");
    // } else if (target.isDarwin()) {
    //     exe.linkFramework("Cocoa");
    //     exe.linkFramework("IOKit");
    // } else {
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("Xrandr");
    exe.linkSystemLibrary("Xi");
    exe.linkSystemLibrary("pthread");
    exe.linkSystemLibrary("dl");
    exe.linkSystemLibrary("m");
    // }

    // Set up installation
    b.installArtifact(exe);

    // Add run step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
