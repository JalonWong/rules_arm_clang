''' base '''

GREEN = "\033[0;32m"
RED = "\033[0;31m"
YELLOW = "\033[0;33m"
COLOR_END = "\033[0m"

def print_info(msg):
    # buildifier: disable=print
    print("\n%s%s%s\n" % (GREEN, msg, COLOR_END))

def print_warn(msg):
    # buildifier: disable=print
    print("\n%s%s %s\n" % (YELLOW, msg, COLOR_END))

def print_error(msg):
    # buildifier: disable=print
    print("\n%s%s %s\n" % (RED, msg, COLOR_END))

def fail_error(msg):
    fail("\n%s%s %s\n" % (RED, msg, COLOR_END))

def resolve_labels(repository_ctx, labels):
    return dict([(label, repository_ctx.path(Label(label))) for label in labels])

def get_ext(repository_ctx):
    if "windows" in repository_ctx.os.name:
        return ".exe"
    else:
        return ""

def find_python(repository_ctx):
    path = repository_ctx.which("python3")
    if path == None:
        path = repository_ctx.which("python")

    if path == None:
        fail_error("python not found in PATH!")
        return ""
    else:
        return str(path)

# def get_armclang_version(repository_ctx, arm_path):
#     ver_py = repository_ctx.path(Label("@rules_arm_clang//toolchain:arm_clang_version.py"))
#     python = find_python(repository_ctx)
#     result = repository_ctx.execute([python, ver_py, arm_path])
#     if result.return_code == 0:
#         return result.stdout.strip()
#     else:
#         return ""

def get_armclang_version(repository_ctx, arm_path):
    armclang = "/".join([arm_path, "bin", "armclang"])
    result = repository_ctx.execute([armclang, "--version"])

    if result.return_code == 0:
        output = result.stdout.strip().lower()
        n = output.find("arm compiler")
        if n < 0:
            return ""

        version = ""
        for i in range(n, len(output)):
            c = output[i]
            if (c >= '0' and c <= '9') or c == '.':
                version += c
            elif len(version) > 0:
                break
        return version
    else:
        return ""

def find_toolchain_path(repository_ctx, toolchain_name):
    """find toolchain path

    Args:
      repository_ctx:
      toolchain_name:

    Returns:
      toolchain path
    """
    path = repository_ctx.which(toolchain_name)
    if path == None:
        path = ""
    else:
        path = str(path)

    if path == "":
        fail_error("{} not found in PATH!".format(toolchain_name))
    else:
        path = path.replace("/bin/" + toolchain_name + get_ext(repository_ctx), "")

    return path

def _print_aspect_impl(_target, ctx):
    workspace_root = ctx.label.workspace_root
    if workspace_root and workspace_root[-1] != "/":
        workspace_root += "/"
    package = workspace_root + ctx.label.package

    # print("-----------", package)
    if hasattr(ctx.rule.attr, "srcs"):
        for src in ctx.rule.attr.srcs:
            for f in src.files.to_list():
                # buildifier: disable=print
                print("file=" + f.path)

    if hasattr(ctx.rule.attr, "defines"):
        for d in ctx.rule.attr.defines:
            # buildifier: disable=print
            print("define=" + d)

    if hasattr(ctx.rule.attr, "includes"):
        h = "include="
        if package:
            h += package

        for i in ctx.rule.attr.includes:
            # print("--", i)
            if i == ".":
                if package:
                    # buildifier: disable=print
                    print(h)
            elif package:
                # buildifier: disable=print
                print(h + "/" + i)
            else:
                # buildifier: disable=print
                print(h + i)

    return []

print_aspect = aspect(
    implementation = _print_aspect_impl,
    attr_aspects = ["deps"],
)
