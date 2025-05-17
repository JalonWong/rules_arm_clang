""" Config """

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
    "tool_path",
    "variable_with_value",
)

# Options -----------------------------------------------------------------------------------------

DEFAULT_COPTS = [
    "-Wall",
    "-Werror",
    "-Wno-comment",
    "-Wno-unused-const-variable",
    "-Wno-unused-function",
    "-Wno-packed",
    "-Wno-missing-variable-declarations",
    "-Wno-missing-prototypes",
    "-Wno-missing-noreturn",
    "-Wno-sign-conversion",
    "-Wno-nonportable-include-path",
    "-Wno-reserved-id-macro",
    "-Wno-unused-macros",
    "-Wno-documentation-unknown-command",
    "-Wno-documentation",
    "-Wno-parentheses-equality",
    "-funsigned-char",
    "-fshort-enums",
    "-fshort-wchar",
    "-g",
    "-gdwarf-3",
    "-ffunction-sections",
]

DEFAULT_CXXOPTS = [
    "-fno-exceptions",
    "-fno-rtti",
]

DEFAULT_LINKOPTS = [
    "--strict",
    "--summary_stderr",
    "--entry", "Reset_Handler"
]

ASM_FLAGS = [
    "--xref",
    "--diag_suppress=A1950W",
    # "-g",
]

# -------------------------------------------------------------------------------------------------

def wrapper_path(ctx, tool):
    return "{}/bin/{}{}".format("%{arm_root_path}", tool, "%{wrapper_ext}")

def wrapper_tool_path(ctx, name, tool):
    return tool_path(name = name, path = wrapper_path(ctx, tool))

def new_feature(name, actions, flags):
    return feature(
        name = name,
        enabled = True,
        flag_sets = [
            flag_set(
                actions = actions,
                flag_groups = [
                    flag_group(flags = flags),
                ] if flags else [],
            ),
        ],
    )

def _config_asm(ctx, action_configs, features):
    # Assembly tool
    action_configs.append(action_config(
        action_name = ACTION_NAMES.assemble,
        tools = [tool(path = wrapper_path(ctx, "armasm"))],
    ))

    # Assembly flags
    features.append(new_feature(
        "asm_flags",
        [
            ACTION_NAMES.assemble,
            ACTION_NAMES.preprocess_assemble,
        ],
        ctx.attr.asm_flags + ASM_FLAGS,
    ))

def _config_c_cpp(ctx, _action_configs, features):
    base_flags = ctx.attr.compiler_flags + DEFAULT_COPTS + ["-c"]
    c_flags = base_flags + '%{optional_cflags}'.split(' ')
    cpp_flags = base_flags + DEFAULT_CXXOPTS + '%{optional_cflags}'.split(' ')

    # C flags
    features.append(new_feature(
        "c_flags",
        [
            ACTION_NAMES.c_compile,
        ],
        c_flags + [
            "-fdebug-prefix-map=%{work_dir}=.",
        ],
    ))

    # CPP flags
    features.append(new_feature(
        "cpp_flags",
        [
            ACTION_NAMES.cpp_compile,
            ACTION_NAMES.cpp_header_parsing,
            ACTION_NAMES.cpp_module_compile,
        ],
        cpp_flags + [
            "-fdebug-prefix-map=%{work_dir}=.",
        ],
    ))

    # User flags must be placed after default flags
    features.append(feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.c_compile,
                    ACTION_NAMES.cpp_compile,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                    ),
                ],
            ),
        ],
    ))

    # Replace default include flags
    features.append(feature(
        name = "include_paths",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.c_compile,
                    ACTION_NAMES.cpp_compile,
                    ACTION_NAMES.cpp_header_parsing,
                    ACTION_NAMES.cpp_module_compile,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["-I", "%{include_paths}"],
                        iterate_over = "include_paths",
                    ),
                    flag_group(
                        flags = ["-I", "%{system_include_paths}"],
                        iterate_over = "system_include_paths",
                    ),
                ],
            ),
        ],
    ))

def _config_ar(_ctx, _action_configs, features):
    features.append(feature(
        name = "archiver_flags",
        flag_sets = [
            flag_set(
                actions = [ACTION_NAMES.cpp_link_static_library],
                flag_groups = [
                    flag_group(flags = ["-ruc"]),
                    flag_group(
                        flags = ["%{output_execpath}"],
                        expand_if_available = "output_execpath",
                    ),
                ],
            ),
            flag_set(
                actions = [ACTION_NAMES.cpp_link_static_library],
                flag_groups = [
                    flag_group(
                        iterate_over = "libraries_to_link",
                        flag_groups = [
                            flag_group(
                                flags = ["%{libraries_to_link.name}"],
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "object_file",
                                ),
                            ),
                            flag_group(
                                flags = ["%{libraries_to_link.object_files}"],
                                iterate_over = "libraries_to_link.object_files",
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "object_file_group",
                                ),
                            ),
                        ],
                        expand_if_available = "libraries_to_link",
                    ),
                ],
            ),
        ],
    ))

def _config_linker(ctx, action_configs, features):
    base_flags = ctx.attr.link_flags + DEFAULT_LINKOPTS

    # Link tool
    action_configs.append(action_config(
        action_name = ACTION_NAMES.cpp_link_executable,
        tools = [tool(path = wrapper_path(ctx, "armlink"))],
    ))

    features.append(feature(
        name = "strip_debug_symbols",
        enabled = False,
    ))

    # Output map file
    map_flag = ["--info", "summarysizes",
            "--map", "--load_addr_map_info", "--xref", "--callgraph", "--symbols",
            "--info", "sizes",
            "--info", "totals",
            "--info", "unused",
            "--info", "veneers",
            "--list", "%{output_execpath}.map",
            ]

    # Link flags
    features.append(new_feature(
        "link_flags",
        [
            ACTION_NAMES.cpp_link_executable,
        ],
        base_flags + map_flag,
    ))

    features.append(feature(
        name = "user_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.cpp_link_executable,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["%{user_link_flags}"],
                        iterate_over = "user_link_flags",
                    ),
                ],
            ),
        ],
    ))

    features.append(feature(
        name = "libraries_to_link",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.cpp_link_executable,
                ],
                flag_groups = [
                    flag_group(
                        iterate_over = "libraries_to_link",
                        flag_groups = [
                            flag_group(
                                flags = ["%{libraries_to_link.object_files}"],
                                iterate_over = "libraries_to_link.object_files",
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "object_file_group",
                                ),
                            ),
                            flag_group(
                                flags = ["%{libraries_to_link.name}"],
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "object_file"
                                )
                            ),
                            flag_group(
                                flags = ["%{libraries_to_link.name}"],
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "interface_library",
                                ),
                            ),
                            flag_group(
                                flags = ["%{libraries_to_link.name}"],
                                expand_if_equal = variable_with_value(
                                    name = "libraries_to_link.type",
                                    value = "static_library"
                                )
                            )
                        ]
                    ),
                ],
            ),
        ],
    ))

    features.append(new_feature(
        "output_execpath_flags",
        [
            ACTION_NAMES.cpp_link_executable,
        ],
        ["-o", "%{output_execpath}"],
    ))

def _impl(ctx):
    tool_paths = [
        wrapper_tool_path(ctx, "gcc", "armclang"),
        wrapper_tool_path(ctx, "ld", "armlink"),
        wrapper_tool_path(ctx, "ar", "armar"),
        wrapper_tool_path(ctx, "cpp", "armclang"),
        wrapper_tool_path(ctx, "gcov", "none"),
        wrapper_tool_path(ctx, "nm", "none"),
        wrapper_tool_path(ctx, "objdump", "none"),
        wrapper_tool_path(ctx, "strip", "none"),
    ]

    action_configs = []
    features = []

    # Disable default input flags
    features.append(feature(
        name = "compiler_input_flags",
        enabled = False,
    ))

    _config_asm(ctx, action_configs, features)
    _config_c_cpp(ctx, action_configs, features)
    _config_ar(ctx, action_configs, features)
    _config_linker(ctx, action_configs, features)

    # Replace the order of files
    features.append(new_feature(
        "compiler_output_flags",
        [
            ACTION_NAMES.assemble,
            ACTION_NAMES.preprocess_assemble,
            ACTION_NAMES.c_compile,
            ACTION_NAMES.cpp_compile,
            ACTION_NAMES.cpp_header_parsing,
            ACTION_NAMES.cpp_module_compile,
        ],
        ["-o", "%{output_file}", "%{source_file}"],
    ))

    # Compiler include path
    builtin_includes = ["%{arm_root_path}/include"]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "armclang",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "unknown",
        target_libc = "unknown",
        compiler = "armclang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        action_configs = action_configs,
        tool_paths = tool_paths,
        features = features,
        cxx_builtin_include_directories = builtin_includes,
    )

arm_clang_config = rule(
    implementation = _impl,
    attrs = {
        "asm_flags": attr.string_list(),
        "compiler_flags": attr.string_list(default = []),
        "link_flags": attr.string_list(default = []),
    },
    provides = [CcToolchainConfigInfo],
)
