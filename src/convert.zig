const std = @import("std");
const ConvertError = error{NoInteger};
pub fn toInteger(comptime T: type, s: []const u8) !T {
    var sum: T = 0;
    var start: usize = 0;
    if (s[0] == '-') {
        start = 1;
    }
    for (s[start..], 0..) |digit, idx| {
        if (digit == '.') {
            return ConvertError.NoInteger;
        }
        sum += (digit - 48) * std.math.pow(T, 10, @intCast(s.len - idx - 1 - start));
    }

    if (start != 1) {
        return sum;
    } else {
        return -sum;
    }
}

pub fn toInt(s: []const u8) !i32 {
    return toInteger(i32, s);
}

pub fn toDouble(s: []const u8) !f64 {
    var dotpos: usize = 0;
    const alloc = std.heap.c_allocator;
    var tmp = std.ArrayList(u8).init(alloc);
    defer tmp.deinit();
    for (s, 0..) |digit, i| {
        if (digit == '.') {
            dotpos = i;
            continue;
        }
        try tmp.append(digit);
    }

    const scaleInt: f64 = @floatFromInt(try toInteger(i64, tmp.items));
    const div: f64 = @floatFromInt(std.math.pow(i64, 10, @intCast(s.len - dotpos - 1)));

    const result = scaleInt / div;

    return result;
}

pub fn integerToString(comptime T: type, num: T) ![]const u8 {
    const alloc = std.heap.c_allocator;
    var s = std.ArrayList(u8).init(alloc);
    defer s.deinit();

    var num_changed = num;
    var start: usize = 0;
    if (num < 0) {
        num_changed = -num;
        start = 1;
    }
    while (@divFloor(num_changed, 10) != 0) {
        const char: u8 = @intCast(@mod(num_changed, 10) + 48);
        try s.append(char);
        num_changed = @divFloor(num_changed, 10);
    }

    const char: u8 = @intCast(@mod(num_changed, 10) + 48);
    try s.append(char);

    var s_rev = std.ArrayList(u8).init(alloc);
    if (start == 1) {
        try s_rev.append('-');
    }
    for (s.items, 0..) |_, i| {
        try s_rev.append(s.items[s.items.len - i - 1]);
    }
    defer s_rev.deinit();

    std.debug.print("{s}\n", .{s_rev.items});

    return s_rev.items;
}

test "convert" {
    const s = [_][]const u8{ "123", "-357", "23", "56", "-78" };
    const exps = [_]i64{ 123, -357, 23, 56, -78 };

    for (s, 0..) |e, i| {
        try std.testing.expectEqual(exps[i], try toInt(e));
    }

    const double_s = [_][]const u8{ "1.23", "-8.2", "23.865", "-823.65", "-88.07" };
    const double_exps = [_]f64{ 1.23, -8.2, 23.865, -823.65, -88.07 };

    for (double_s, 0..) |e, i| {
        try std.testing.expectEqual(double_exps[i], try toDouble(e));
    }
}
