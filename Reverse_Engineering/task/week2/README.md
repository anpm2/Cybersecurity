# Week 2
**Task**: Chương trình asm

## Task 1: Nhân 2 số
(không tràn thanh ghi, thừa số trong đoạn [0, 2^32 - 1] với 32 bit, [0, 2^64 - 1] với 64 bit)
  - Cho phép nhập 2 số
  - Tính nhân
  - In kết quả
> * Source: [Code by Cyman_AT20N linux_x86](https://github.com/anpm2/Cybersecurity/blob/286e289162db88475d6893c59f60365d44105819/Reverse_Engineering/task/week2/mul_2nums-linux_x86.asm)
```asm
; Code on linux_x86 by Cyman_AT20N

section .data       ; khai báo dữ liệu tĩnh và bộ nhớ
    msg1 db "Nhap so thu nhat: ", 0
    len1 equ $-msg1                 ; độ dài chuỗi số thứ nhất

    msg2 db "Nhap so thu hai: ", 0
    len2 equ $-msg2

    msg3 db "Ket qua phep nhan: "
    len3 equ $-msg3

    err_msg db "Dau vao khong hop le!", 0xA, 0xD
    err_len equ $-err_msg

section .bss    ; phần khai báo dữ liệu chưa khởi tạo, dùng để lưu trữ input và kết quả
    num1 resb 21  ; Dự trữ 21 byte cho số đầu tiên (20 chữ số + ký tự newline)
    num2 resb 21
    res resb 22   ; Dự trữ 22 byte cho kết quả (20 chữ số + null terminator)

section .text   ; phần bắt đầu của mã thực thi
    global _start   ; điểm bắt đầu của chương trình

_start:
    ; in ra thông báo nhập số thứ nhất
    mov eax, 4          ; Gọi syscall 'write'
    mov ebx, 1          ; file descriptor (stdout) --> Đầu ra chuẩn (màn hình)
    mov ecx, msg1       ; Chuỗi thông báo đầu tiên
    mov edx, len1       ; Độ dài thông báo
    int 0x80            ; gọi kernel để ngắt

    ; đọc số thứ nhất
    mov eax, 3          ; Gọi syscall 'read'
    mov ebx, 0          ; Đầu vào chuẩn (bàn phím)
    mov ecx, num1       ; Địa chỉ lưu trữ số đầu tiên
    mov edx, 21         ; Số byte cần đọc (21 byte)
    int 0x80

    ; kiểm tra tính hợp lệ của đầu vào
    call validate_input
    test eax, eax       ; Kiểm tra kết quả validate (eax == 0?)
    jz print_error      ; Nếu không hợp lệ (eax == 0), nhảy đến hàm in lỗi

    ; in ra thông báo nhập số thứ 2
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; đọc số thứ 2
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 21
    int 0x80

    ; kiểm tra tính hợp lệ của đầu vào
    call validate_input
    test eax, eax
    jz print_error

    ; chuyển chuỗi số đầu tiên thành số nguyên
    mov esi, num1   ; gán địa chỉ của chuỗi số đầu tiên
    xor eax, eax    ; Xóa eax
    xor ebx, ebx    ; Xóa ebx (sẽ chứa giá trị số đầu tiên)

.parse_num1:
    movzx ecx, byte [esi]   ; Lấy từng ký tự trong chuỗi
    cmp ecx, 0xA            ; So sánh với ký tự newline (đầu vào kết thúc)
    je .num1_parsed         ; Nếu gặp newline, nhảy đến .num1_parsed
    sub ecx, '0'            ; Chuyển đổi ký tự thành giá trị số
    imul eax, eax, 10       ; Nhân eax với 10 (dịch trái số hiện tại)
    add eax, ecx            ; Cộng giá trị số vào eax
    inc esi                 ; Tăng con trỏ esi để lấy ký tự tiếp theo
    jmp .parse_num1         ; Lặp lại cho đến khi gặp newline

.num1_parsed:
    mov ebx, eax            ; Lưu giá trị số đầu tiên vào ebx

    ; chuyển chuỗi số thứ 2 thành số nguyên
    mov esi, num2
    xor eax, eax
    xor edx, edx

.parse_num2:
    movzx ecx, byte [esi]
    cmp ecx, 0xA
    je .num2_parsed
    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp .parse_num2

.num2_parsed:
    ; Nhân 2 số eax = eax * ebx
    imul eax, ebx

    ; Chuyển đổi kết quả thành chuỗi và lưu vào res
    mov esi, res            ; Địa chỉ lưu trữ kết quả dưới dạng chuỗi
    mov ebx, eax            ; Lưu giá trị kết quả vào ebx
    xor ecx, ecx            ; Xóa ecx (sẽ dùng để đếm số chữ số)

.convert_to_string:
    xor edx, edx            ; Xóa edx (sẽ chứa phần dư)
    mov edi, 10             ; Chia kết quả cho 10
    div edi                 ; eax = thương, edx = phần dư
    add dl, '0'             ; Chuyển đổi phần dư thành ký tự ASCII
    mov [esi + ecx], dl     ; Lưu ký tự vào chuỗi kết quả
    inc ecx                 ; Tăng ecx (độ dài của chuỗi)
    test eax, eax           ; Kiểm tra nếu thương là 0
    jnz .convert_to_string  ; Nếu là 0 thì tiếp tục chuyển đổi

    mov byte [esi + ecx], 0 ; Kết thúc chuỗi bằng ký tự null

    ; Đảo ngược chuỗi trong res
    mov ebx, esi            ; ebx trỏ đến đầu chuỗi
    add ebx, ecx            ; ebx trỏ đến cuối chuỗi (trước ký tự null)
    dec ebx                 ; Lùi ebx để trỏ đến ký tự cuối cùng
    mov esi, res            ; esi trỏ đến đầu chuỗi

.reverse_string:
    cmp esi, ebx            ; So sánh con trỏ đầu (esi) và cuối (ebx)
    jge .done_reversing     ; Nếu esi >= ebx, kết thúc đảo ngược
    mov al, [esi]           ; Nếu esi < ebx, lấy ký tự tại vị trí esi
    mov dl, [ebx]           ; Lấy ký tự tại vị trí ebx
    mov [esi], dl           ; Đổi vị trí ký tự từ ebx về esi
    mov [ebx], al           ; Đổi vị trí ký tự từ esi về ebx
    inc esi                 ; Tăng esi để trỏ đến ký tự tiếp theo
    dec ebx                 ; Giảm ebx để trỏ về ký tự trước đó
    jmp .reverse_string     ; Lặp lại quá trình

.done_reversing:
    ; In ra kết quả
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, ecx           ; Sử dụng ecx để xác định độ dài chuỗi
    int 0x80

    ; Thoát chương trình
    mov eax, 1              ; Gọi syscall 'exit'
    xor ebx, ebx            ; Trả về mã kết thúc 0
    int 0x80

print_error:
    ; Hiển thị thông báo lỗi khi nhập không hợp lệ được phát hiện
    mov eax, 4
    mov ebx, 1
    mov ecx, err_msg
    mov edx, err_len
    int 0x80

    ; Thoát chương trình với mã lỗi
    mov eax, 1
    mov ebx, 1
    int 0x80

validate_input:
    ; Kiểm tra đầu vào để đảm bảo chỉ có ký tự số
    mov esi, num1           ; Địa chỉ của chuỗi đầu vào
    xor eax, eax            ; Đặt eax về 0

.validate_loop:
    movzx ecx, byte [esi]    ; Lấy từng ký tự trong chuỗi
    cmp ecx, 0xA             ; So sánh với ký tự newline (kết thúc đầu vào)
    je .done_validation      ; Nếu gặp newline, hoàn tất kiểm tra
    cmp ecx, '0'             ; Kiểm tra ký tự có nhỏ hơn '0' không
    jb .invalid_input        ; Nếu có, đầu vào không hợp lệ
    cmp ecx, '9'             ; Kiểm tra ký tự có lớn hơn '9' không
    ja .invalid_input        ; Nếu có, đầu vào không hợp lệ
    inc esi                  ; Tăng con trỏ esi để lấy ký tự tiếp theo
    jmp .validate_loop       ; Lặp lại quá trình

.done_validation:
    mov eax, 1              ; Đầu vào hợp lệ, trả về 1
    ret

.invalid_input:
    mov eax, 0              ; Đầu vào không hợp lệ, trả về 0
    ret
```

**Giải thích:**
* **`section .data`**: Chứa các biến dữ liệu đã được khởi tạo (ví dụ: chuỗi thông báo)
* **`section .bss`**: Chứa các biến chưa được khởi tạo, dùng để lưu trữ dữ liệu nhập từ người dùng 
* **`section .text`**: Chứa mã lệnh thực thi của chương trình.

  **1. Xử lý số sau khi nhập:**
   ```asm
      call validate_input
      test eax, eax
      jz print_error
  ```

  * Hàm **`validate_input`** kiểm tra tính hợp lệ của đầu vào. Nếu không hợp lệ, nhảy đến **`print_error`**.
  
  ```asm
  print_error:
      mov eax, 4
      mov ebx, 1
      mov ecx, err_msg
      mov edx, err_len
      int 0x80
  
      ; Thoát chương trình với mã lỗi
      mov eax, 1
      mov ebx, 1
      int 0x80
  
  validate_input:
      mov esi, num1           
      xor eax, eax            
  
  .validate_loop:
      movzx ecx, byte [esi]    
      cmp ecx, 0xA             
      je .done_validation      
      cmp ecx, '0'             
      jb .invalid_input        
      cmp ecx, '9'             
      ja .invalid_input        
      inc esi                  
      jmp .validate_loop       
  
  .done_validation:
      mov eax, 1              
      ret
  
  .invalid_input:
      mov eax, 0              
      ret
  ```
  
  * Hàm **`validate_input`** kiểm tra từng ký tự của chuỗi đầu vào để đảm bảo rằng tất cả đều là ký tự số từ '0' đến '9'.
  * Vòng lặp **`validate_loop`** kiểm tra từng ký tự trong chuỗi num1, đảm bảo chúng là các ký tự số.
    * Nếu tất cả các ký tự hợp lệ, hàm trả về 1.
    * Nếu phát hiện ký tự không phải số, trả về 0.
  * Tương tự cho số thứ 2
  
  **2. Chuyển đổi chuỗi thành số nguyên**
  ```asm
      mov esi, num1
      xor eax, eax
      xor ebx, ebx
  
  .parse_num1:
      movzx ecx, byte [esi]   
      cmp ecx, 0xA            
      je .num1_parsed     
      sub ecx, '0'            
      imul eax, eax, 10       
      add eax, ecx            
      inc esi                 
      jmp .parse_num1         
  
  .num1_parsed:
      mov ebx, eax
  ```
  * Vì nhập vào từ màn hình console thì hệ thống coi các số được nhập là tập hợp các byte chứa mã **ASCII** đại diện cho các chữ số đó **(hiểu là chuỗi ký tự)** nên cần chuyển từ chuỗi ký tự sang số để thực hiện tính toán.
  * Hàm **`.parse_num1`** chuyển đổi chuỗi thành số nguyên bằng cách duyệt từng ký tự, trừ đi giá trị của ký tự '0' để có giá trị số thực tế, rồi nhân kết quả hiện tại với 10 (để dịch trái) và cộng thêm giá trị số vừa chuyển đổi.
  * Tương tự cho số thứ 2.
  
  **3. Nhân 2 số và chuyển kết quả thành chuỗi**
  ```asm
  .num2_parsed:
      imul eax, ebx
  
      mov esi, res            
      mov ebx, eax            
      xor ecx, ecx            
  
  .convert_to_string:
      xor edx, edx            
      mov edi, 10             
      div edi                 
      add dl, '0'             
      mov [esi + ecx], dl     
      inc ecx
      test eax, eax           
      jnz .convert_to_string  
  
      mov byte [esi + ecx], 0
  ```
  * `imul eax, ebx`: Nhân giá trị của num1 và num2.
  * **`convert_to_string`**: Chuyển đổi kết quả từ số nguyên thành chuỗi ký tự.
  * Chia kết quả cho 10 để lấy phần dư(**edx**) và chuyển thành ký tự ASCII tương ứng, sau đó lưu vào chuỗi **res**.
  * Lặp lại cho đến khi thương(**eax**) bằng 0.
  
  **4. Đảo ngược chuỗi và in kết quả**
  ```asm
      mov ebx, esi     
      add ebx, ecx            
      dec ebx                 
      mov esi, res            
  
  .reverse_string:
      cmp esi, ebx            
      jge .done_reversing     
      mov al, [esi]           
      mov dl, [ebx]           
      mov [esi], dl           
      mov [ebx], al           
      inc esi                 
      dec ebx                 
      jmp .reverse_string
  ```
  * Chuỗi **res** ban đầu sẽ bị ngược, vì vậy thực hiện đảo ngược chuỗi để có được kết quả đúng.
  
  ```asm
  .done_reversing:
      ; In ra kết quả
      mov eax, 4
      mov ebx, 1
      mov ecx, msg3
      mov edx, len3
      int 0x80
  
      mov eax, 4
      mov ebx, 1
      mov ecx, res
      mov edx, ecx           
      int 0x80
  
      ; Thoát chương trình
      mov eax, 1              
      xor ebx, ebx            
      int 0x80
  ```
  * Hàm **`.done_reversing`** in kết quả và thoát chương trình.

* Compile, link and excute on linux_x86:
![](https://github.com/anpm2/Cybersecurity/blob/0705dc89e0df67a4889fba74bf8f10f43c8b059f/Reverse_Engineering/task/week2/image/1.png)


---
## Task 2: Cộng 2 số tự nhiên lớn 
(tràn thanh ghi, số hạng trong đoạn [0, 2^64 - 1] với 32 bit, [0, 2^128 - 1] với 64 bit)
  - Cho phép nhập 2 số
  - Tính cộng
  - In kết quả
---


## Task 3: Tìm index của substring
(giống string.find(substring) python)
  - Nhập 2 chuỗi: string A, substring B
  - Tìm vị trí khớp đầu tiên của B trong A
  - In kết quả
> * Source: [Code by Cyman_AT20N linux_x86](https://github.com/anpm2/Cybersecurity/blob/286e289162db88475d6893c59f60365d44105819/Reverse_Engineering/task/week2/index_sub_str_x86.asm)

```asm
; Code on linux_x86 by Cyman_AT20N
section .data
    msga db "Nhập string (A): ", 0
    lena equ $-msga
    msgb db "Nhập the substring (B): ", 0
    lenb equ $-msgb

    err db "Substring not found", 0xA
    lenerr equ $-err

section .bss
    string_a resb 100     ; Dự trữ 100 byte cho chuỗi A
    substring_b resb 50   ; Dự trữ 50 byte cho chuỗi B

section .text
    global _start

_start:
    ; Yêu cầu người dùng nhập chuỗi A
    mov eax, 4
    mov ebx, 1
    mov ecx, msga
    mov edx, lena
    int 0x80

    ; Đọc chuỗi A
    mov eax, 3
    mov ebx, 0
    mov ecx, string_a
    mov edx, 100
    int 0x80

    ; Loại bỏ ký tự newline ở cuối chuỗi A
    push string_a
    call remove_newline
    add esp, 4              ; Khôi phục stack sau khi gọi hàm

    ; Yêu cầu người dùng nhập chuỗi B
    mov eax, 4
    mov ebx, 1
    mov ecx, msgb
    mov edx, lenb
    int 0x80

    ; Đọc chuỗi B
    mov eax, 3
    mov ebx, 0
    mov ecx, substring_b
    mov edx, 50
    int 0x80

    ; Loại bỏ ký tự newline ở cuối chuỗi B
    push substring_b
    call remove_newline
    add esp, 4

    ; Gọi hàm tìm substring
    xor ecx, ecx           ; Khởi tạo chỉ số cho chuỗi chính A
    push substring_b       ; Đẩy địa chỉ của chuỗi con B vào stack
    push string_a          ; Đẩy địa chỉ của chuỗi chính A vào stack
    call find_substring    ; Khôi phục stack sau khi gọi hàm
    add esp, 8

    ; Kiểm tra kết quả
    cmp eax, -1            ; Nếu không tìm thấy (kết quả trả về là -1)
    je  not_found_msg

    ; In kết quả index nếu tìm thấy 
    call print_index

    ; Thoát chương trình
    call exit_program

not_found_msg:
    ; In thông báo "Substring not found"
    push lenerr
    push err
    call print_string
    add esp, 8
    call exit_program

; Hàm tìm vị trí của substring trong chuỗi
find_substring:
    push ebp
    mov ebp, esp
    push ebx
    mov ebx, [ebp + 8]     ; Lấy địa chỉ của string A từ stack
    mov esi, [ebp + 12]    ; Lấy địa chỉ của substring B từ stack
    xor eax, eax           ; Đặt index = 0

next_char:
    ; Kiểm tra kết thúc chuỗi A
    cmp byte [ebx + ecx], 0
    je  not_found_return   ; Nếu hết chuỗi mà chưa khớp, trả về -1

    ; So sánh chuỗi con B với chuỗi A từ vị trí hiện tại
    push esi               ; Đẩy địa chỉ của chuỗi con B vào stack
    lea eax, [ebx + ecx]
    push eax               ; Đẩy địa chỉ hiện tại trong A vào stack
    call compare_strings
    add esp, 8             ; Khôi phục stack sau khi gọi hàm

    ; Nếu khớp, trả về chỉ số
    test eax, eax
    jz  found_match

    ; Tiếp tục tìm
    inc ecx
    jmp next_char

not_found_return:
    mov eax, -1            ; Không tìm thấy
    jmp find_substring_end

found_match:
    mov eax, ecx           ; Đặt chỉ số vào eax

find_substring_end:
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; Hàm so sánh chuỗi con với chuỗi chính
compare_strings:
    push ebp
    mov ebp, esp
    mov edi, [ebp + 8]     ; Lấy địa chỉ chuỗi chính từ stack
    mov esi, [ebp + 12]    ; Lấy địa chỉ chuỗi con từ stack
    xor edx, edx           ; Dùng edx như là chỉ số so sánh

compare_loop:
    mov al, [edi + edx]
    cmp al, [esi + edx]
    jne not_match
    cmp byte [esi + edx], 0 ; Nếu chuỗi con đã hết và khớp toàn bộ, báo khớp
    je match
    inc edx
    jmp compare_loop

not_match:
    mov eax, 1             ; Không khớp
    jmp compare_end

match:
    xor eax, eax           ; Khớp (trả về 0)

compare_end:
    mov esp, ebp
    pop ebp
    ret

; Hàm loại bỏ ký tự newline ở cuối chuỗi
remove_newline:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]     ; Địa chỉ chuỗi
    mov ecx, -1
    mov al, 0              ; ký tự kết thúc chuỗi

find_newline:
    inc ecx
    cmp byte [ebx + ecx], 0
    je newline_done
    cmp byte [ebx + ecx], 10 ; Kiểm tra ký tự newline (LF)
    jne find_newline

    ; Thay thế newline bằng null
    mov byte [ebx + ecx], al

newline_done:
    mov esp, ebp
    pop ebp
    ret


; Hàm in chỉ số index
print_index:
    push ebp
    mov ebp, esp
    sub esp, 12            ; Dành 12 byte trên stack cho chuỗi số

    mov ecx, 10            ; Cơ số 10
    mov edi, esp           ; Đặt edi trỏ đến vùng nhớ trên stack
    add edi, 11            ; Di chuyển edi đến cuối vùng nhớ
    mov byte [edi], 0      ; Null-terminate chuỗi

convert_loop:
    xor edx, edx           ; Xóa edx
    div ecx                ; Chia eax cho 10
    add dl, '0'            ; Thêm giá trị ASCII của '0'
    dec edi                ; Dời con trỏ
    mov [edi], dl          ; Lưu kết quả
    test eax, eax          ; Kiểm tra eax có bằng 0 không
    jnz convert_loop       ; Nếu không, tiếp tục chia

    ; In kết quả
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, esp
    add edx, 12
    sub edx, edi
    int 0x80

    mov esp, ebp
    pop ebp
    ret

; Hàm in chuỗi
print_string:
    push ebp
    mov ebp, esp
    mov eax, 4
    mov ebx, 1
    mov ecx, [ebp + 8]     ; Lấy địa chỉ chuỗi từ stack
    mov edx, [ebp + 12]    ; Lấy độ dài chuỗi từ stack
    int 0x80
    mov esp, ebp
    pop ebp
    ret

; Hàm thoát chương trình
exit_program:
    mov eax, 1
    xor ebx, ebx           ; mã thoát (0)
    int 0x80
```

**Giải thích:**
* **`section .data`**: Chứa các biến dữ liệu đã được khởi tạo (ví dụ: chuỗi thông báo)
* **`section .bss`**: Chứa các biến chưa được khởi tạo, dùng để lưu trữ dữ liệu nhập từ người dùng 
* **`section .text`**: Chứa mã lệnh thực thi của chương trình.

   **1. Xử lý chuỗi sau khi nhập:**
   ```asm
  ; Loại bỏ ký tự newline ở cuối chuỗi A
   push string_a
   call remove_newline
   add esp, 4
  ```
  * Hàm **`remove_newline`** được gọi để loại bỏ ký tự newline (LF) ở cuối chuỗi A, thường xuất hiện sau khi người dùng nhấn **Enter**.
  * Tương tự cho chuỗi B
  
   **2. Tìm kiếm chuỗi con:**
  ```asm
  xor ecx, ecx
  push substring_b
  push string_a
  call find_substring
  add esp, 8
  ```
  * Chuẩn bị cho việc tìm kiếm bằng cách khởi tạo chỉ số chuỗi chính và đẩy địa chỉ của chuỗi chính và chuỗi con vào **stack**.
  * Gọi hàm **`find_substring`** để tìm kiếm chuỗi con trong chuỗi chính.
  
   **3. Kiểm tra kết quả:**
  ```asm
  cmp eax, -1
  je  not_found_msg
  
  call print_index
  call exit_program
  
  not_found_msg:
  push lenerr
  push err
  call print_string
  add esp, 8
  call exit_program
  ```
  * Nếu không tìm thấy chuỗi con (**eax** = -1), in thông báo lỗi và thoát.
  * Nếu tìm thấy, gọi **`print_index`** để in vị trí đầu tiên mà chuỗi con xuất hiện, sau đó thoát chương trình.
  
   **4. Hàm find_substring:**
  ```asm
  find_substring:
      ...
  ```
  * Duyệt từng ký tự trong chuỗi chính A và so sánh với chuỗi con B bằng cách gọi hàm **`compare_strings`**.
  * Nếu tìm thấy, trả về vị trí; nếu không, tiếp tục tìm kiếm.
  
   **5. Hàm compare_strings:**
  ```asm
  compare_strings:
      ...
  ```
  * So sánh từng ký tự của chuỗi con với chuỗi chính từ vị trí hiện tại.
  * Nếu toàn bộ chuỗi con khớp, trả về 0 (match); nếu không khớp tại bất kỳ ký tự nào, trả về 1 (not match).
  ---
   **6. Hàm remove_newline:**
  ```asm
  remove_newline:
      ...
  ```
  * Tìm ký tự newline (**LF**) trong chuỗi và thay thế nó bằng ký tự **null** (\0), đánh dấu kết thúc chuỗi.

   **7. Hàm print_index và print_string:**
  * print_index: Chuyển đổi chỉ số tìm thấy thành chuỗi và in ra màn hình.
  * print_string: In chuỗi với độ dài xác định.

   **8. Hàm exit_program:**
  ```asm
  exit_program:
      mov eax, 1
      xor ebx, ebx
      int 0x80
  ```
  * Kết thúc chương trình với syscall exit(0).

* Kết quả sau khi compile, link và excute
![](https://github.com/anpm2/Cybersecurity/blob/0705dc89e0df67a4889fba74bf8f10f43c8b059f/Reverse_Engineering/task/week2/image/2.png)

