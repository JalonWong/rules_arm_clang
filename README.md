# ARM Clang Rules for Bazel
Compilation rules for `armclang`, also known as Arm Compiler 6.

## Dependence
- bazel v8+
- armclang

## Getting Started
First, install `armclang` compiler, for example by installing Keil MDK.

Then, add the path of `armclang` to the environment variable `PATH`, for example `C:\Keil_v5\ARM\ARMCLANG\bin`.
Ues `armclang --version` to confirm that the environment variable has taken effect.

Add the following to your `MODULE.bazel` file:
```python
bazel_dep(name = "rules_arm_clang", version="<version>")
```

Add the following to your `.bazelrc` file:
```shell
common --registry=https://raw.githubusercontent.com/JalonWong/bazel-registry/main/
common --registry=https://raw.githubusercontent.com/bazelbuild/bazel-central-registry/main/

build --incompatible_enable_cc_toolchain_resolution
build --platforms=@rules_arm_clang//:cm3 # depends on your platform
```

Then, in your `BUILD` file:
```python
cc_library(
    ...
)

cc_binary(
    ...
)
```

## Platforms
- cm3 - Cortex M3
- cm4 - Cortex M4.fp.sp (Hardware float point)
- cm4s - Cortex M4 (software float point)
- cm23 - Cortex M23
- cm33 - Cortex M33

## Generate artifacts
```python
load("@rules_arm_clang//:gen.bzl", "gen_bin", "gen_hex", "gen_asm")

cc_binary(
    name = "app.elf",
    ...
)

gen_bin(
    name = "app.bin",
    input = ":app.elf",
)

gen_hex(
    name = "app.hex",
    input = ":app.elf",
)

gen_asm(
    name = "app_asm.txt",
    input = ":app.elf",
)
```
## Build Example
```shell
cd example
bazel build example
```
