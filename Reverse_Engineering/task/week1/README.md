# WEEK 1
> [!NOTE]
> Minh An_AT20N CymanKMA
> 
**Task**: Tìm hiểu các khái niệm cơ bản như thanh ghi, instructions, stack, endianness, calling convention 

## Table of Contents


## I. Register
* Thanh ghi là một bộ nhớ dung lượng nhỏ và rất nhanh được sử dụng để tăng tốc độ xử lý của các chương trình.

### 1. Thanh ghi đa năng
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/1.png)

* Xét thanh ghi trong kiến trúc x86:
#### 1.1 Thanh ghi dữ liệu
* Dùng lưu trữ số liệu để CPU xử lý vd cho số học,logic, ... 
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/2.png)
* `AX` là bộ tích luỹ đầu tiên, nó được dùng trong nhập xuất và hầu hết các instruction số học. Ví dụ trong phép nhân, 1 toán hạng được lưu vào EAX hoặc AX hoặc AL tuỳ theo kích cỡ của toán hạng đó.
* `BX` là thanh ghi cơ sở (base register) được dùng để đánh số địa chỉ
* `CX` là thanh ghi đếm (count register) được dùng như để đếm số vòng lặp
* `DX` là thanh ghi dữ liệu, nó cũng được sử dụng trong hoạt động nhập xuất tương tự như AX.

#### 1.2 Thanh ghi con trỏ
* Lưu trữ địa chỉ bộ nhớ của một vị trí dữ liệu nào đó. 
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/3.png)
* `Instruction Pointer (IP)` - lưu trữ địa chỉ offset của instruction tiếp theo để thực thi.
* `Stack pointer (SP)` - cung cấp giá trị offset nằm trong ngăn xếp chương trình. (trỏ tới đỉnh ngăn xếp)
* `Base Pointer (BP)` - tham chiếu biến tham số truyền tới chương trình con. (biến cục bộ)

#### 1.3 Thanh ghi chỉ số
* Dùng để đánh số địa chỉ và đôi lúc dùng trong phép cộng và trừ. Truy cập các phần tử trong mảng.
    * Source Index (SI) - được dùng đánh số của nguồn cho chuỗi operations.
    * Destination Index (DI) - ngược lại với source

### 2. Thanh ghi điều khiển
 * Thanh ghi 32-bit con trỏ và 32-bit cờ (flags) kết hợp được coi là thanh ghi điểu khiển.
 * Các bit flag chính:
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/4.png)

### 3. Thanh ghi đoạn
 * CS : Thanh ghi đoạn mã lưu trữ vị trí cơ sở của phần mã (section .text) được sử dụng để truy cập dữ liệu.
 * DS : Thanh ghi phân đoạn dữ liệu lưu trữ vị trí mặc định cho các biến (phần .data) được sử dụng để truy cập dữ liệu.
 * SS: chứa dữ liệu và địa chỉ trả về của các chương trình con.
 * ES : Thanh ghi phân đoạn bổ sung được sử dụng trong các hoạt động chuỗi.
 * FS : Thanh ghi phân đoạn bổ sung.
 * GS : Thanh ghi phân đoạn bổ sung.

## II. Instructions
 * Lệnh là một tập hợp các bit mã hóa, được CPU hiểu và thực hiện để thực hiện một thao tác cụ thể.
   * `Mã op-code`: Đây là phần xác định loại hoạt động mà lệnh sẽ thực hiện (ví dụ: cộng, trừ, nhảy).
   * `Các toán hạng`: Đây là dữ liệu mà lệnh sẽ hoạt động, có thể là các giá trị trực tiếp, địa chỉ bộ nhớ hoặc các thanh ghi.
 * Cú pháp: [ label ] mnemonic [operands] [;comment]
 * Ví dụ: `mov total, 48`: Chuyển giá trị 48 vào biến nhớ total trong đó `mov` là mnemonic(op-code), `total, 48` là toán hạng)

## III. Stack
 * Là một vùng nhớ được tổ chức theo nguyên tắc LIFO (Last In, First Out)
     * Push: Đẩy một phần tử vào đỉnh của ngăn xếp.
     * Pop: Lấy phần tử ở đỉnh của ngăn xếp ra.
     * Peek: Xem phần tử ở đỉnh của ngăn xếp mà không lấy nó ra.


## IV. Endianess
 * Chỉ cách thức các byte của một số đa byte (số có nhiều hơn 8 bit) được sắp xếp trong bộ nhớ máy tính.
 * Quyết định byte nào sẽ được đặt ở vị trí đầu tiên (địa chỉ thấp nhất) và byte nào sẽ được đặt ở vị trí cuối cùng (địa chỉ cao nhất).
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/5.png)


## V. Calling convention
 * Quy tắc gọi hàm định nghĩa rõ ràng cách các hàm truyền tham số, trả về giá trị và quản lý ngăn xếp.
 * Ví dụ:
   * Trong các tệp nhị phân 32 bit trên Linux, các đối số hàm được truyền vào ngăn xếp theo thứ tự ngược lại.(cdecl)
   * Đối với các tệp nhị phân 64 bit, các đối số hàm lần đầu tiên được truyền vào các thanh ghi nhất định:
     ```
     RDI
     RSI
     RDX
     RCX
     R8
     R9
     ```
 * Sau đó mọi đối số còn sót lại sẽ được đẩy lên ngăn xếp theo thứ tự ngược lại, như trong cdecl. 

## VI. Chương tình Hello world bằng asm

> Source: [Code by Cyman_AT20N linux_x86](https://github.com/anpm2/Cybersecurity/blob/94afbf2b4a2ec73b99352d7dd71d899c876e9129/Reverse_Engineering/task/week1/hello_word-linux_x86.asm)

```asm
;code on linux-32bit by Cyman

section .data               ; khai báo dữ liệu khởi tạo, hằng
    msg     db  'Hello wordl!', 0xA ;khai báo chuỗi msg, ký tự xuống dòng (0xA)
    len_msg equ $ - msg     ;độ dài chuỗi

section .text               ;nơi thực thi dòng lệnh
    global _start           ;báo cho hệ điều hành biết nơi chương trình có thể được 
                            ;tìm thấy và thực thi
                            
_start:                     ;cho biết điểm đầu vào của chương trình
    mov     eax,    4       ;gọi hệ thống (sys_write) 
    mov     ebx,    1       ;file descriptor (stdout) --> Đầu ra chuẩn (màn hình)
    mov     ecx,    msg     ;gán địa chỉ của chuỗi vào ecx
    mov     edx,    len_msg ;gán địa chỉ của độ dài chuỗi vào edx
    int     0x80            ;gọi kernel để ngắt
    
    mov     eax,    1       ;gọi hệ thống (sys_exit) 
    int     0x80
```
 * Giải thích:
   - Trong section .data:
     - Khai báo chuỗi `msg` kiểu byte (db)
     - Định nghĩa biến `len_msg` lấy độ dài chuỗi msg = địa chỉ hiện tại trừ đi địa chỉ msg
   - Trong section .text:
     - `_start`: cho biết điểm bắt đầu của chương trình
     - Thực hiện các thao tác gọi hệ thống đọc file chuẩn đầu ra màn hình in ra chuỗi
     - 2 dòng cuối của code thoát khỏi chương trình sau khi thực hiện xong yêu cầu giúp tránh lỗi `Segmentation fault` 

 ### Compile và link file .asm
 * Lưu chương trình Hello world với tên file là `hello_word-linux_x86.asm`
 * Gõ `nasm -f elf32 hello_word-linux_x86.asm` để compile và tạo ra file object tên là `hello_word-linux_x86.o`
 * Link file object để tạo file excute gõ: `ld -m i_386 hello_word-linux_x86.o -o hello_word-linux_x86`
 * Cuối cùng gõ `./hello_word-linux_x86` để excute file và in ra dòng chữ `Hello world!` ra màn hình.
![](https://github.com/anpm2/Cybersecurity/blob/bd450c77b0696d22a4eb9883f616f77596317b4a/Reverse_Engineering/task/week1/image/6.png)

