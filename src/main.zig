const std = @import("std");
const c = @cImport({
    @cInclude("GL/glew.h");
    @cInclude("GLFW/glfw3.h");
});

pub fn main() !void {
    std.debug.print("Initializing GLFW...\n", .{});
    if (c.glfwInit() != c.GLFW_TRUE) {
        return error.GLFWInitializationFailed;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    std.debug.print("Creating GLFW window...\n", .{});
    const window = c.glfwCreateWindow(800, 600, "Hello World", null, null) orelse {
        std.debug.print("Failed to create window", .{});
        return error.WindowCreationFailed;
    };
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);

    std.debug.print("Initializign GLEW...\n", .{});
    if (c.glewInit() != c.GLEW_OK) {
        std.debug.print("GLEW failed to initialize\n", .{});
        return error.GLEWInitializationFailed;
    }

    std.debug.print("Running Loop...\n", .{});
    while (c.glfwWindowShouldClose(window) == 0) {
        c.glClearColor(0.3, 0.4, 1.0, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
}
