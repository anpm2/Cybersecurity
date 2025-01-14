from pwn import *

map = [0x0B, 0x08, 0x03, 0x04, 0x01, 0x00, 0x0E, 0x0D, 0x0F, 0x09, 0x0C, 0x06, 0x02, 0x05, 0x07, 0x0A, 
       0x0F, 0x04, 0x08, 0x0B, 0x06, 0x07, 0x0D, 0x02, 0x0C, 0x03, 0x05, 0x0E, 0x0A, 0x00, 0x01, 0x09, 
       0x04, 0x0C, 0x0E, 0x05, 0x0D, 0x06, 0x09, 0x0A, 0x01, 0x00, 0x0B, 0x0F, 0x02, 0x07, 0x03, 0x08, 
       0x0A, 0x08, 0x0F, 0x03, 0x04, 0x06, 0x00, 0x0B, 0x01, 0x0D, 0x09, 0x07, 0x05, 0x02, 0x0C, 0x0E, 
       0x0B, 0x06, 0x09, 0x0F, 0x02, 0x01, 0x0A, 0x0E, 0x03, 0x0C, 0x0D, 0x00, 0x05, 0x04, 0x08, 0x07, 
       0x09, 0x04, 0x0B, 0x05, 0x06, 0x0F, 0x08, 0x00, 0x03, 0x01, 0x0A, 0x0D, 0x02, 0x0E, 0x0C, 0x07, 
       0x0A, 0x0E, 0x09, 0x07, 0x08, 0x0D, 0x03, 0x0B, 0x0C, 0x0F, 0x02, 0x00, 0x04, 0x05, 0x06, 0x01, 
       0x05, 0x04, 0x0D, 0x01, 0x00, 0x02, 0x09, 0x0B, 0x0C, 0x07, 0x08, 0x0A, 0x06, 0x0E, 0x0F, 0x03, 
       0x04, 0x08, 0x05, 0x02, 0x0A, 0x0F, 0x0B, 0x07, 0x00, 0x01, 0x0C, 0x03, 0x0E, 0x06, 0x09, 0x0D, 
       0x0D, 0x0E, 0x0F, 0x0B, 0x00, 0x02, 0x0A, 0x04, 0x07, 0x06, 0x09, 0x01, 0x05, 0x03, 0x08, 0x0C,
       0x0E, 0x02, 0x03, 0x05, 0x0A, 0x01, 0x07, 0x00, 0x09, 0x0D, 0x0C, 0x0B, 0x04, 0x06, 0x0F, 0x08, 
       0x03, 0x0B, 0x0E, 0x0A, 0x06, 0x04, 0x07, 0x01, 0x02, 0x0D, 0x0F, 0x00, 0x0C, 0x09, 0x05, 0x08, 
       0x0D, 0x0F, 0x01, 0x02, 0x0C, 0x0A, 0x03, 0x07, 0x09, 0x06, 0x08, 0x05, 0x00, 0x04, 0x0B, 0x0E, 
       0x00, 0x0E, 0x04, 0x0D, 0x06, 0x01, 0x0A, 0x05, 0x03, 0x0C, 0x07, 0x0B, 0x0F, 0x02, 0x08, 0x09, 
       0x0B, 0x02, 0x08, 0x07, 0x05, 0x03, 0x09, 0x0D, 0x04, 0x0F, 0x00, 0x01, 0x06, 0x0C, 0x0E, 0x0A, 
       0x0B, 0x01, 0x08, 0x00, 0x0C, 0x0D, 0x04, 0x0E, 0x0A, 0x06, 0x0F, 0x07, 0x09, 0x05, 0x03, 0x02]

def find_original(shuffled):
    original = [''] * 64

    for j in range(15, -1, -1):
        for k in range(15, -1, -1):
            if (j & 1) != 0:
                original[k + 32] = shuffled[map[16 * j + k]]
            else:
                shuffled[k] = original[map[16 * j + k] + 32]

    return shuffled[:16]# Trả về chuỗi gốc ban đầu

host = "host1.dreamhack.games"
port = 16452
p = remote(host, port)

#p = process('./many-shuffle')

context.log_level = 'debug'

p.recvuntil('Shuffled String: ')
data = bytearray(p.recv(16))

payloadd = find_original(data)
p.sendline(payloadd)

response = p.recvall()
print(response)

p.close()