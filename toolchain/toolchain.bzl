load("@rules_cc//cc:defs.bzl", "cc_toolchain")
load(":config.bzl", "arm_clang_config")

TOOLCHAINS = [
    "cm3",
    "cm4",
    "cm4s",
    "cm23",
    "cm33",
]

def arm_toolchains():
    arm_clang_config(
        name = "arm_clang_config_cm3",
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

    arm_clang_config(
        name = "arm_clang_config_cm4",
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

    arm_clang_config(
        name = "arm_clang_config_cm4s",
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

    arm_clang_config(
        name = "arm_clang_config_cm23",
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

    arm_clang_config(
        name = "arm_clang_config_cm33",
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

    native.filegroup(
        name = "files",
        srcs = [],
    )

    for t in TOOLCHAINS:
        cc_toolchain(
            name = "cc_toolchain_{}".format(t),
            all_files = ":files",
            ar_files = ":files",
            compiler_files = ":files",
            dwp_files = ":files",
            linker_files = ":files",
            objcopy_files = ":files",
            strip_files = ":files",
            supports_param_files = 0,
            toolchain_config = ":arm_clang_config_{}".format(t),
            toolchain_identifier = "armclang",
        )

        native.toolchain(
            name = t,
            target_compatible_with = [
                "@rules_arm_clang//:cortex_{}".format(t[1:]),
            ],
            toolchain = ":cc_toolchain_{}".format(t),
            toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        )
