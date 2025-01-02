import os
from pwn import *
from capstone import *
from os.path import getsize
from os import listdir

# Init Capstone disassembler cho x86_64
md = Cs(CS_ARCH_X86, CS_MODE_64)


def get_so_files():
    so_files = [(getsize('lib/' + f), 'lib/' + f) for f in listdir('./lib') if f.endswith('.so')]
    so_files.sort()
    
    # file return giá trị và các file còn lại
    ret_files = [so for so in so_files if so[0] == so_files[0][0]]
    other_files = [so for so in so_files if so[0] != so_files[0][0]]
    return ret_files, other_files

# Tìm hàm có lệnh return 1
def analyze_function_return(so_path):
    elf = ELF(so_path)
    for sym in elf.symbols:
        if sym.startswith("f_"):
            offset = elf.symbols[sym]
            code = elf.read(offset, 0x13)  # Đọc 19 byte từ offset
            
            for ins in md.disasm(code, offset):
                if ins.mnemonic == "mov" and ins.op_str == "eax, 1":
                    print(f"    {hex(ins.address)}:\t{ins.mnemonic}\t{ins.op_str}")
                    print(f'\n-->Found "return 1" in func {sym} at file {so_path}!')
                    return sym[2:]  # Trả về ký tự sau 'f_'
    return None

# Lấy mapping giữa các hàm và file .so tương ứng
def get_function_mapping(filename):
    elf = ELF(filename)
    result = []
    
    try:
        for c in '0123456789abcdef':
            func = elf.functions['f_' + c]
            offset = func.address + 0x27

            # Tính địa chỉ của tên file .so tiếp theo
            next_so_addr = func.address + 0x2b + u16(elf.data[offset:offset+2])
            next_so_name = elf.string(next_so_addr).decode()
            
            result.append([filename, c, next_so_name])
    finally:
        elf.close()
    
    return result

# Xây dựng map các kết nối giữa các file .so
def build_so_map(other_files):
    so_map = {}
    for _, so_filename in other_files:
        for curr_file, char, next_file in get_function_mapping(so_filename):
            if next_file not in so_map:
                so_map[next_file] = []
            so_map[next_file].append((char, curr_file))
    return so_map

def main():
    ret_files, other_files = get_so_files()
    
    ##############################################################
    # for _, so_path in ret_files:                               #
    #     func_name = f'f_{analyze_function_return(so_path)}'    #
    #     if func_name:                                          #
    #         break                                              #
    # else: print("[-] Not found!")                              #
    ##############################################################
    # Found 'return 1' in func f_8 at file ./lib/219f2e3164.so!

    flag = '8'
    current_file = 'lib/219f2e3164.so'
    
    # Xây dựng map và tìm các ký tự tiếp theo
    so_map = build_so_map(other_files)
    while current_file != 'lib/start.so':
        connections = so_map.get(current_file)
        print(f"{connections} --> {current_file}")
        flag += connections[0][0]
        current_file = connections[0][1]
    
    # Đảo ngược chuỗi và in flag
    flag = flag[::-1]
    print(f'\nFlag: DH{{{flag}}}')


main()