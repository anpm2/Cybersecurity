key = [0xDE, 0xAD, 0xBE, 0xEF]

enc = open('encrypted', 'rb').read()

dec = [0]*len(enc)
i = 0
for i in range(len(enc)):
    dec[i] = (enc[i] - 19) % 256 ^ key[i % 4]

dec = bytes(dec)
with open('flag.png', 'wb') as f:
    f.write(dec)