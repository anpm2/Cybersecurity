from hashlib import md5
from pwn import *

enc = [ 0xFE5D3A093968D02B, 0xBA0AA367C2862EAE, 
        0x8BEA2ADA9E26604F, 0x2E6F41C96DCF5224,
        0x7FD91BD2949B75F3, 0x05B1ED8E6072F3A6, 
        0xC94045C6D4887611, 0x9D43DF6DF6B94D95,
        0xB9A8A83C8AC08D80, 0x6D78E80376518464, 
        0x0E81A20F2023C2D0, 0x2E41EAE69D89F186,
        0x425C831DD2A3E5FD, 0x82788DBBDC4100EC, 
        0x6D0FEE8D3901DD20, 0xEBE82A0A41E5D783,
        0x2AFA26414B72E506, 0x0D1848E9C21D114D ]

def dec_3_chars(target):
    for i in range(32, 128):
        for j in range(32, 128):
            for k in range(32, 128):
                input = chr(i) + chr(j) + chr(k)
                if md5(input.encode()).digest() == target:
                    return input

flag = ''
for i in range(len(enc) // 2):
    hash = p64((enc[i * 2])) + p64(enc[i * 2 + 1])
    print(hash.hex(), end='\n')
    flag += dec_3_chars(hash)
print(f"\nFlag: {flag}\n") 

# Flag: DH{m-d-5_1s_vu1n-er-4b1e~!}
