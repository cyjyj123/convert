# Introduction
An easy formats convert library for Zig.

# Requirements
```
Zig >=0.13.0
```

# Install
```
zig fetch <url> // Or Download and add it to build.zig.zon manually.
// Then, in build.zig of your project, write it after exe.
const convert=b.dependency("convert").module("convert");
exe.root_module.addImport("convert",convert);
```

# Usage
If you don't change the name,
```
const convert=@import("convert");
// ...
convert.toInteger(comptime T:type,s:[]const u8) !T; // Convert String to integer type such as i32 and i64.
convert.toInt(s:[]const u8):!i32; // Convert String to i32.
convert.toDouble(s:[]const u8):!f64; // Convert String to f64.
```

# Tests
Run `zig test src/convert.zig`

# License
MIT
