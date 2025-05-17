""" ARM Clang """

load("@rules_arm_clang//:base.bzl",
    "resolve_labels",
    "find_python",
    "find_toolchain_path",
    "print_info",
    "print_warn",
    "get_ext",
)

def _impl(repository_ctx):
    paths = resolve_labels(repository_ctx, [
        "@rules_arm_clang//toolchain:BUILD",
        "@rules_arm_clang//toolchain:toolchain.bzl",
        "@rules_arm_clang//toolchain:config.bzl.tpl",
        "@rules_arm_clang//toolchain:gen.bzl.tpl",
    ])

    repository_ctx.symlink(paths["@rules_arm_clang//toolchain:BUILD"], "BUILD")
    repository_ctx.symlink(paths["@rules_arm_clang//toolchain:toolchain.bzl"], "toolchain.bzl")

    arm_path = find_toolchain_path(repository_ctx, "armclang")

    optional_cflags = []
    ver_py = repository_ctx.path(Label("@rules_arm_clang//toolchain:arm_clang_version.py"))

    python = find_python(repository_ctx)
    # print([python, ver_py, arm_path])
    result = repository_ctx.execute([python, ver_py, arm_path])

    if result.return_code == 0:
        version = result.stdout.strip()
        print_info("ARM Clang version: {}".format(version))
        vl = version.split(".")
        version_int = int(vl[0]) * 1000 + int(vl[1])
        if version_int >= 6018:
            optional_cflags.append("-Wno-unused-but-set-variable")
    else:
        print_warn("ARM Clang compiler not found in {}".format(arm_path))

    work_dir = str(repository_ctx.path("../../execroot/_main"))

    repository_ctx.template(
        "config.bzl",
        paths["@rules_arm_clang//toolchain:config.bzl.tpl"],
        {
            "%{arm_root_path}": arm_path,
            "%{optional_cflags}": " ".join(optional_cflags),
            "%{work_dir}": work_dir,
            "%{wrapper_ext}": get_ext(repository_ctx),
        },
    )
    repository_ctx.template(
        "gen.bzl",
        paths["@rules_arm_clang//toolchain:gen.bzl.tpl"],
        {"%{arm_root_path}": arm_path},
    )

arm_repository = repository_rule(
    implementation = _impl,
    configure = True,
)

def _toolchains_ext_impl(_module_ctx):
    # Generate repo of toolchains
    arm_repository(name = "arm_clang_")

toolchains_ext = module_extension(
    implementation = _toolchains_ext_impl,
)
