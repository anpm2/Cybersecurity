from pwn import xor

enc = bytearray(b'|l|GHyRrsfwxmsIrietznhIhj')
print(len(enc))

def shift_right(enc, shift):
    shift %= len(enc)
    return enc[-shift:] + enc[:-shift]

def shift_left(enc, shift):
    shift %= len(enc)
    return enc[shift:] + enc[:shift]

key = b'qksrkqs'
enc = shift_left(enc, 3)
enc = xor(enc, key)
enc = shift_right(enc, 3)
enc = xor(enc, key)
enc = shift_left(enc, 3)

print(enc)
# b'DH{ShiftxorShiftxorShift}'