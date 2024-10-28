from pwn import *
from string import printable

context.log_level="critical"

flag = ""

out = bytes.fromhex(open("output.txt", "r").read())
for i in range(len(out)):
    for j in printable:
        input = (flag + j).ljust(len(out), "A")
        p = process("./legacyopt")
        p.sendline(input.encode())
        res = bytes.fromhex((p.recv(2*len(out))).decode())
        p.close()
        if res[i] == out[i]:
            flag += j
            break

print(flag)
