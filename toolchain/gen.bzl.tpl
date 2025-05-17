""" Generate """

FROMELF = "%{arm_root_path}/bin/fromelf"

def arm_gen_bin(ctx, input, output, inputs):
    ctx.actions.run(
        outputs = [output],
        inputs = [input] + inputs,
        arguments = ["--bin", input.path, "--output", output.path],
        executable = FROMELF,
    )


def arm_gen_hex(ctx, input, output, inputs):
    ctx.actions.run(
        outputs = [output],
        inputs = [input] + inputs,
        arguments = ["--i32", input.path, "--output", output.path],
        executable = FROMELF,
    )

def arm_gen_asm(ctx, input, output):
    ctx.actions.run(
        outputs = [output],
        inputs = [input],
        arguments = ["--text", "-c", input.path, "--output", output.path],
        executable = FROMELF,
    )
