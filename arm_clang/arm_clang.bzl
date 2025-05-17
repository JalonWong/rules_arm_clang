""" ARM Clang """

load("@rules_arm_clang//:base.bzl",
    "resolve_labels",
    "find_toolchain_path",
    "print_info",
    "print_warn",
    "get_ext",
)

def _impl(repository_ctx):
    paths = resolve_labels(repository_ctx, [
        "@rules_arm_clang//arm_clang/toolchain:BUILD",
        "@rules_arm_clang//arm_clang/toolchain:config.bzl.tpl",
        "@rules_arm_clang//arm_clang/toolchain:gen.bzl.tpl",
        "@rules_arm_clang//arm_clang:BUILD",
    ])

    repository_ctx.symlink(paths["@rules_arm_clang//arm_clang/toolchain:BUILD"], "toolchain/BUILD")
    repository_ctx.symlink(paths["@rules_arm_clang//arm_clang:BUILD"], "BUILD")

    armclang_path = find_toolchain_path(repository_ctx, "armclang")

    optional_cflags = []
    armclang_ver_py = repository_ctx.path(Label("@rules_arm_clang//arm_clang:armclang_version.py"))

    # print(['python', armclang_ver_py, armclang_path])
    result = repository_ctx.execute(["python", armclang_ver_py, armclang_path])

    if result.return_code == 0:
        version = result.stdout.strip()
        print_info("armclang version: {}".format(version))
        vl = version.split(".")
        version_int = int(vl[0]) * 1000 + int(vl[1])
        if version_int >= 6018:
            optional_cflags.append("-Wno-unused-but-set-variable")
    else:
        print_warn("armclang compiler not found in {}".format(armclang_path))

    compile_root = str(repository_ctx.path("../../execroot/_main"))

    repository_ctx.template(
        "toolchain/config.bzl",
        paths["@rules_arm_clang//arm_clang/toolchain:config.bzl.tpl"],
        {
            "%{armclang_root_path}": armclang_path,
            "%{optional_cflags}": " ".join(optional_cflags),
            "%{compile_root}": compile_root,
            "%{wrapper_ext}": get_ext(repository_ctx),
        },
    )
    repository_ctx.template(
        "toolchain/gen.bzl",
        paths["@rules_arm_clang//arm_clang/toolchain:gen.bzl.tpl"],
        {"%{armclang_root_path}": armclang_path},
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
