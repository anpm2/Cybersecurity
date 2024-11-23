from Cryptodome.Cipher import AES

# Chuỗi đã mã hóa (byte_A14068)
encrypted_data = bytes([
    0x5D, 0x0DE, 0x8C, 0x0AC, 0x0AE, 0x0E2, 0x2D, 0x9F, 0x0F2, 0x49, 0x3F, 0x18, 0x35, 0x09, 0x3C, 0x9E, 
    0x0EF, 0x0C5, 0x0D1, 0x14, 0x0A5, 0x78, 0x02, 0x97, 0x18, 0x5A, 0x0E8, 0x0A0, 0x8E, 0x4C, 0x0DD, 0x19, 
    0x74, 0x5C, 0x0E4, 0x9B, 0x29, 0x95, 0x0B8, 0x0D7, 0x0B9, 0x7D, 0x0D0, 0x56, 0x0BD, 0x94, 0x99, 0x72, 
    0x0FF, 0x58, 0x0B9, 0x1E, 0x57, 0x0E9, 0x0DA, 0x27, 0x0D5, 0x0A9, 0x4D, 0x0F5, 0x0B6, 0x3B, 0x07, 0x46, 
    0x0C8, 0x0DB, 0x37, 0x6E, 0x77, 0x95, 0x97, 0x0FA, 0x7F, 0x5D, 0x4D, 0x54, 0x86, 0x0DA, 0x0E3, 0x17
])

# Khóa mã hóa (byte_A1441C)
key = bytes([
    0xBB, 0x8C, 0x8C, 0x09, 0x51, 0xE8, 0x1C, 0x3C, 0x56, 0x8C, 0x72, 0x81, 0xA3, 0x96, 0x46, 0x3B,
    0x0F, 0x0E, 0x05, 0x87, 0xBE, 0xA9, 0x9A, 0x26, 0x7A, 0xF1, 0x59, 0x83, 0x2E, 0x71, 0x7F, 0x06
])

# Vector khởi tạo (IV) (byte_A144D0)
iv = bytes([
    0x3E, 0xC2, 0xCD, 0x75, 0x41, 0x45, 0x60, 0xE8, 0xD2, 0x75, 0xA6, 0xBF, 0x6F, 0xC3, 0x75, 0x1D
])

# Tạo đối tượng AES sử dụng chế độ CBC
cipher = AES.new(key, AES.MODE_CBC, iv)

# Giải mã dữ liệu
decrypted_data = cipher.decrypt(encrypted_data)

# In ra flag ban đầu (chuỗi đã được giải mã)
print(decrypted_data.decode('utf-8', errors='ignore'))  # Ignore errors if non-printable characters exist