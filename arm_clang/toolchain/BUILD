load(":config.bzl", "armclang_config")

filegroup(
    name = "files",
    srcs = [],
)

# CM3 -------------------------------------------------------------------------

toolchain(
    name = "cm3",
    target_compatible_with = [
        "@rules_arm_clang//:cortex_m3",
    ],
    toolchain = ":toolchain_cm3",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "toolchain_cm3",
    all_files = ":files",
    ar_files = ":files",
    compiler_files = ":files",
    dwp_files = ":files",
    linker_files = ":files",
    objcopy_files = ":files",
    strip_files = ":files",
    supports_param_files = 0,
    toolchain_config = ":armclang_config_cm3",
    toolchain_identifier = "armclang",
)

armclang_config(
    name = "armclang_config_cm3",
    asm_flags = [
        "--cpu=Cortex-M3",
    ],
    compiler_flags = [
        "--target=arm-arm-none-eabi",
        "-mcpu=cortex-m3",
    ],
    link_flags = [
        "--cpu=Cortex-M3",
    ],
)

# CM4 -------------------------------------------------------------------------

toolchain(
    name = "cm4",
    target_compatible_with = [
        "@rules_arm_clang//:cortex_m4",
    ],
    toolchain = ":toolchain_cm4",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "toolchain_cm4",
    all_files = ":files",
    ar_files = ":files",
    compiler_files = ":files",
    dwp_files = ":files",
    linker_files = ":files",
    objcopy_files = ":files",
    strip_files = ":files",
    supports_param_files = 0,
    toolchain_config = ":armclang_config_cm4",
    toolchain_identifier = "armclang",
)

armclang_config(
    name = "armclang_config_cm4",
    asm_flags = [
        "--cpu=Cortex-M4.fp.sp",
    ],
    compiler_flags = [
        "--target=arm-arm-none-eabi",
        "-mcpu=cortex-m4",
        "-mfpu=fpv4-sp-d16",
        "-mfloat-abi=hard",
    ],
    link_flags = [
        "--cpu=Cortex-M4.fp.sp",
    ],
)

# CM4S ------------------------------------------------------------------------

toolchain(
    name = "cm4s",
    target_compatible_with = [
        "@rules_arm_clang//:cortex_m4s",
    ],
    toolchain = ":toolchain_cm4s",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "toolchain_cm4s",
    all_files = ":files",
    ar_files = ":files",
    compiler_files = ":files",
    dwp_files = ":files",
    linker_files = ":files",
    objcopy_files = ":files",
    strip_files = ":files",
    supports_param_files = 0,
    toolchain_config = ":armclang_config_cm4s",
    toolchain_identifier = "armclang",
)

armclang_config(
    name = "armclang_config_cm4s",
    asm_flags = [
        "--cpu=Cortex-M4",
        "--fpu=SoftVFP",
    ],
    compiler_flags = [
        "--target=arm-arm-none-eabi",
        "-mcpu=cortex-m4",
        "-mfpu=none",
        "-mfloat-abi=soft",
    ],
    link_flags = [
        "--cpu=Cortex-M4",
        "--fpu=SoftVFP",
    ],
)

# CM23 ------------------------------------------------------------------------

toolchain(
    name = "cm23",
    target_compatible_with = [
        "@rules_arm_clang//:cortex_m23",
    ],
    toolchain = ":toolchain_cm23",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "toolchain_cm23",
    all_files = ":files",
    ar_files = ":files",
    compiler_files = ":files",
    dwp_files = ":files",
    linker_files = ":files",
    objcopy_files = ":files",
    strip_files = ":files",
    supports_param_files = 0,
    toolchain_config = ":armclang_config_cm23",
    toolchain_identifier = "armclang",
)

armclang_config(
    name = "armclang_config_cm23",
    asm_flags = [
        "--cpu=Cortex-M23",
    ],
    compiler_flags = [
        "--target=arm-arm-none-eabi",
        "-mcpu=cortex-m23",
    ],
    link_flags = [
        "--cpu=Cortex-M23",
    ],
)

# CM33 ------------------------------------------------------------------------

toolchain(
    name = "cm33",
    target_compatible_with = [
        "@rules_arm_clang//:cortex_m33",
    ],
    toolchain = ":toolchain_cm33",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain(
    name = "toolchain_cm33",
    all_files = ":files",
    ar_files = ":files",
    compiler_files = ":files",
    dwp_files = ":files",
    linker_files = ":files",
    objcopy_files = ":files",
    strip_files = ":files",
    supports_param_files = 0,
    toolchain_config = ":armclang_config_cm33",
    toolchain_identifier = "armclang",
)

armclang_config(
    name = "armclang_config_cm33",
    asm_flags = [
        "--cpu=Cortex-M33",
    ],
    compiler_flags = [
        "--target=arm-arm-none-eabi",
        "-mcpu=cortex-m33",
        "-mfpu=fpv5-sp-d16",
        "-mfloat-abi=hard",
    ],
    link_flags = [
        "--cpu=Cortex-M33",
    ],
)
