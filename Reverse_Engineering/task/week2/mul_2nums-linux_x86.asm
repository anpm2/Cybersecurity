; Code on linux_x86 by Cyman

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
