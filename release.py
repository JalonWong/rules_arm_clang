import sys
import zipfile
from glob import glob

TAMPLATE = """
`MODULE.bazel`:
```py
bazel_dep(name = "rules_arm_clang", version = "{version}")
```
"""


if __name__ == "__main__":
    tag = sys.argv[1]

    v = tag.replace("v", "")
    with open("release.md", "w") as f:
        f.write(TAMPLATE.format(version=v))

    with open("MODULE.bazel", "r") as f:
        text = f.read().replace("0.0.0", v)
        with open("MODULE.bazel", "w") as f:
            f.write(text)

    with zipfile.ZipFile(f"rules_arm_clang-{tag}.zip", "w", zipfile.ZIP_DEFLATED) as zip_f:
        zip_f.write("BUILD")
        zip_f.write("MODULE.bazel")

        files = glob("*.bzl") + glob("toolchain/**", recursive=True)
        for file in files:
            zip_f.write(file)
