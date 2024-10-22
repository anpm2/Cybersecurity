# Hex string to bytes
#encoded = bytes.fromhex("220c6a33204455fb390074013c4156d704316528205156d70b217c14255b6ce10837651234464e")
    
encoded = bytes.fromhex(open("output.txt", "r").read())

# Key XOR 8 bytes 
key = [0x66, 0x44, 0x11, 0x77, 0x55, 0x22, 0x33, 0x88]
    
decode = ""
for i in range(len(encoded)):
    decoded_byte = encoded[i] ^ key[i % 8]
    decode += chr(decoded_byte)
    

print(decode)
print(len(decode))