const std = @import("std");
const cpp = @cImport({
    @cInclude("hello.h");
});

pub fn main() void {
    cpp.helloWorld();
}

test "call helloWorld from C++" {
    cpp.helloWorld();
}
