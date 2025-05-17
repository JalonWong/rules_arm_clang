''' gen '''

load("@arm_clang_//:gen.bzl", "arm_gen_asm", "arm_gen_bin", "arm_gen_hex")

def _impl_gen(ctx, filetype):
    in_file = ctx.file.input
    input_other = ctx.attr.input_other
    out_file = ctx.actions.declare_file(ctx.label.name)

    if "bin" == filetype:
        arm_gen_bin(ctx, in_file, out_file, input_other)
    elif "hex" == filetype:
        arm_gen_hex(ctx, in_file, out_file, input_other)
    elif "asm" == filetype:
        arm_gen_asm(ctx, in_file, out_file)

    return [
        DefaultInfo(files = depset([out_file])),
    ]

_ATTRS = {
    "input": attr.label(
        allow_single_file = True,
        mandatory = True,
    ),
    "input_other": attr.label_list(default = []),
    "args": attr.string_list(default = []),
}

def _impl_gen_bin(ctx):
    return _impl_gen(ctx, "bin")

gen_bin = rule(
    implementation = _impl_gen_bin,
    attrs = _ATTRS,
)

def _impl_gen_hex(ctx):
    return _impl_gen(ctx, "hex")

gen_hex = rule(
    implementation = _impl_gen_hex,
    attrs = _ATTRS,
)

def _impl_gen_asm(ctx):
    return _impl_gen(ctx, "asm")

gen_asm = rule(
    implementation = _impl_gen_asm,
    attrs = _ATTRS,
)
