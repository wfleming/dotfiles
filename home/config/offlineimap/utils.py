import subprocess

# return the contents of an entry in `pass`
def pass_entry(entry_name):
    p = subprocess.Popen(["pass", entry_name], stdout=subprocess.PIPE)
    p.wait()
    if p.returncode != 0:
        raise "Got non-zero return getting pass entry"
    return p.stdout.read().strip()
