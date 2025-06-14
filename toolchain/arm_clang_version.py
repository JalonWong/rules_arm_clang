import os
import re
import subprocess
import sys

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        arm_path = sys.argv[1]
        if not os.path.exists(arm_path):
            exit(1)
    else:
        exit(1)

    arm_bin = os.path.join(arm_path, "bin", "armclang")
    ret = subprocess.run([arm_bin, "--version"], capture_output=True, text=True)
    if ret.returncode != 0:
        exit(ret.returncode)

    obj = re.search(r"A[rR][mM] Compiler\D+([\d\.]+)", ret.stdout)
    if obj:
        print(obj.group(1))
        exit(0)
    exit(1)
