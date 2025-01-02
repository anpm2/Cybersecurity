# so_what (level 4)

>**Link: [chall](https://github.com/anpm2/Cybersecurity/tree/9938f80aecdf819eabe0dc2c76b4d45d3001af4b/Reverse_Engineering/Write-up/Dream_Hack/so_what/chall)**

* Mở file bằng IDA

![0](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/0.png)
* Phân tích khái quát:
    ![1](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/1.png)
    * Hàm verify sẽ check các ký tự của input từ a-f và 0-9 nếu không thoả sẽ in ra `Wrong input.` và thoát chương trình.

    * Ở hàm main chall yêu cầu người dùng nhập dữ liệu, xác thực dữ liệu và tải hàm từ thư viện động để xử lý. Sau đó, kiểm tra kết quả và in thông báo tương ứng.

    * Flow cụ thể của chương trình như sau: ký tự đầu tiên của input được gán vào `name[2]`, tiếp theo lấy địa chỉ hàm theo tên name từ thư viện động `lib/start.so`. Lần lượt gọi liên tục như thế qua các `lib/...so` còn lại cho đến ký tự cuối cùng, thì sẽ gặp hàm trong `lib/...so` bất kỳ return về giá trị 0 nếu sai input, là 1 nếu đúng input.

    ![2](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/2.png)
    ![3](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/3.png)

* Từ phân tích trên đầu tiên mình sẽ xác định xem tên hàm return 1 nằm trong `/lib/...so` nào, từ đó **backtrack** đến `lib/start.so` để xác định input chính xác.

```python
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
            print(f"  Analyzing function {sym} at offset {hex(offset)}:")
            for ins in md.disasm(code, offset):
                print(f"    {hex(ins.address)}:\t{ins.mnemonic}\t{ins.op_str}")
                if ins.mnemonic == "mov" and ins.op_str == "eax, 1":
                    print(f'\n-->Found "return 1" in func {sym} at file {so_path}!')
                    return sym[2:]  # Trả về ký tự sau 'f_'
    return None

def main():
    ret_files, other_files = get_so_files()
    
    for _, so_path in ret_files:  # Unpack tuple, get only file path
        func_name = analyze_function_return(so_path)
        if func_name:
            break
    else:
        print("[-] Not found!")                              
    # Found 'return 1' in func f_8 at file ./lib/219f2e3164.so!

main()
```

![4](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/4.png)
* Run script trên thì nhận được file`/lib/219f2e3164.so` chứa hàm `f_8` return 1.

![5](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/5.png)
* Check lại = IDA.

* Biết được hàm `f_8` return 1 trong file `/lib/219f2e3164.so`, ta viết script thực hiện **backtrack** lần lượt từ hàm return 1 trong file .so đó trở về file `/lib/start.so` để tìm tên hàm cho input đúng.

```python
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
                print(f"    {hex(ins.address)}:\t{ins.mnemonic}\t{ins.op_str}")
                if ins.mnemonic == "mov" and ins.op_str == "eax, 1":
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
```
<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  DH{20654ccdb7c43bd1ab398283f9895ac285e8c419c4c157db2f3f50de92599bd8}
  ```

</details>

![6](https://github.com/anpm2/Cybersecurity/blob/c62c907dd960b14acc60848997a40410369361c2/Reverse_Engineering/Write-up/Dream_Hack/so_what/image/6.png)
