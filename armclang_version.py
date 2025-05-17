import re
import os
import sys
import subprocess

if __name__ == '__main__':
    if len(sys.argv) >= 2:
        armclang_path = sys.argv[1]
        if not os.path.exists(armclang_path):
            exit(1)
    else:
        exit(1)

    armclang_bin = os.path.join(armclang_path, 'bin', 'armclang')
    ret = subprocess.run([armclang_bin, '--version'], capture_output=True, text=True)
    if ret.returncode != 0:
        exit(ret.returncode)

    searchobj = re.search('A[rR][mM] Compiler\D+([\d\.]+)', ret.stdout)
    if searchobj:
        print(searchobj.group(1))
        exit(0)
    exit(1)
