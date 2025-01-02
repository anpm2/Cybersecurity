enc_data = open("out.bin", "rb").read()
print(len(enc_data), end='\n')
print(enc_data, end = '\n\n')

#enc_data = b'@\xe1\xdc\xd4\x00\x00\x00\x00\xe2\xdf\x83\xa1\x00\x00\x00\x00\x06\xe3c\xc3\x00\x00\x00\x00h\xe2\xd2\xf9\x00\x00\x00\x00\t$\x1a\xc4\x00\x00\x00\x00\xfb\xc0\x9b*\x00\x00\x00\x00\xb5"N\x9a\x00\x00\x00\x00\x9a\xef8}\x00\x00\x00\x00\x9f\x92_\xb1\x00\x00\x00\x00\xef{\xd6\x9e\x00\x00\x00\x00\xe7\xea\xcd\x99\x00\x00\x00\x00'

from Crypto.Util.number import inverse
import struct

def find_d(e, n):
    # Phân tích n thành nhân tử để tìm p và q
    def factorize(n):
        for i in range(2, int(n**0.5) + 1):
            if n % i == 0:
                return i, n//i
        return None
    
    p, q = factorize(n)
    print(f"p = {p}, q = {q}")
    
    # phi(n)
    phi = (p-1)*(q-1)
    
    # Calc private key d
    d = inverse(e, phi)
    return d

def decrypt_flag():
    n = 4271010253
    e = 201326609
    
    d = find_d(e, n)
    print(f"d = {d}")
    
    # Xử lý 8-byte block
    flag = ""
    for i in range(0, len(enc_data), 8):
        # Cconvert to number
        block = enc_data[i:i+8]
        #enc_num = struct.unpack("<Q", block)[0]  # Little-endian 
        enc_num = int.from_bytes(block, 'little')
    
        # Decrypt block 32-bit 
        enc_num &= 0xFFFFFFFF
        
        # Decrypt block
        dec_num = pow(enc_num, d, n)
        
        # Convert to bytes
        dec_bytes = dec_num.to_bytes(4, 'little')
        flag += dec_bytes.decode('ascii')
    return flag


flag = decrypt_flag()
print(f"Flag: {flag}")