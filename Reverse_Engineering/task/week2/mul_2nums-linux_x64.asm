; Code on linux-x64 by Cyman

; định nghĩa các hằng trong system call 
SYS_EXIT  equ 60
SYS_READ  equ 0    
SYS_WRITE equ 1

; định nghĩa các hằng số sử dụng cho file descriptor trong Linux
STDIN     equ 0     ;file descriptor nhập
STDOUT    equ 1     ;file descriptor xuất

segment .data       ; khai báo dữ liệu tĩnh và bộ nhớ
    msg1 db "Nhap so thu nhat: ", 0
    len1 equ $-msg1                 ; độ dài chuỗi số thứ nhất

    msg2 db "Nhap so thu hai: ", 0
    len2 equ $-msg2

    msg3 db "Ket qua phep nhan: "
    len3 equ $-msg3

    err_msg db "Dau vao khong hop le!", 0xA, 0xD
    err_len equ $-err_msg

segment .bss    ; phần khai báo dữ liệu chưa khởi tạo, dùng để lưu trữ input và kết quả
    num1 resb 21  ; Dự trữ 21 byte cho số đầu tiên (20 chữ số + ký tự newline)
    num2 resb 21
    res resb 22   ; Dự trữ 22 byte cho kết quả (20 chữ số + null terminator)

section .text   ; phần bắt đầu của mã thực thi
    global _start   ; điểm bắt đầu của chương trình

_start:
    ; in ra thông báo nhập số thứ nhất
    mov rax, SYS_WRITE  ; Gọi syscall 'write'
    mov rdi, STDOUT     ; Đầu ra chuẩn (màn hình)
    mov rsi, msg1       ; Chuỗi thông báo đầu tiên
    mov rdx, len1       ; Độ dài thông báo
    syscall             ; Thực hiện syscall

    ; đọc số thứ nhất
    mov rax, SYS_READ   ; Gọi syscall 'read'
    mov rdi, STDIN      ; Đầu vào chuẩn (bàn phím)
    mov rsi, num1       ; Địa chỉ lưu trữ số đầu tiên
    mov rdx, 21         ; Số byte cần đọc (21 byte)
    syscall

    ; kiểm tra tính hợp lệ của đầu vào
    call validate_input
    test rax, rax       ; Kiểm tra kết quả validate (rax == 0?)
    jz print_error      ; Nếu không hợp lệ (rax == 0), nhảy đến hàm in lỗi

    ; in ra thông báo nhập số thứ 2
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msg2
    mov rdx, len2
    syscall

    ; đọc số thứ 2
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, num2
    mov rdx, 21
    syscall

    ; kiểm tra tính hợp lệ của đầu vào
    call validate_input
    test rax, rax
    jz print_error

    ; vì đầu vào là chuỗi số nên cần chuyển sang số nguyên để tính toán

    ; chuyển chuỗi số đầu tiên thành số nguyên
    mov rsi, num1   ; gán địa chỉ của chuỗi số đầu tiên
    xor rax, rax    ; Xóa rax
    xor rbx, rbx    ; Xóa rbx (sẽ chứa giá trị số đầu tiên)

.parse_num1:
    movzx rcx, byte [rsi]   ; Lấy từng ký tự trong chuỗi
    cmp rcx, 0xA            ; So sánh với ký tự newline (đầu vào kết thúc)
    je .num1_parsed         ; Nếu gặp newline, nhảy đến .num1_parsed
    sub rcx, '0'            ; Chuyển đổi ký tự thành giá trị số
    imul rax, rax, 10       ; Nhân rax với 10 (dịch trái số hiện tại)
    add rax, rcx            ; Cộng giá trị số vào rax
    inc rsi                 ; Tăng con trỏ rsi để lấy ký tự tiếp theo
    jmp .parse_num1         ; Lặp lại cho đến khi gặp newline

.num1_parsed:
    mov rbx, rax            ; Lưu giá trị số đầu tiên vào rbx


    ; chuyển chuỗi số thứ 2 thành số nguyên
    mov rsi, num2
    xor rax, rax
    xor rdx, rdx

.parse_num2:
    movzx rcx, byte [rsi]
    cmp rcx, 0xA
    je .num2_parsed
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .parse_num2

.num2_parsed:
    ; Nhân 2 số rax = rax * rbx
    imul rax, rbx

    
    ;** linux chỉ in ra chuỗi ký tự vì thế phải chuyển ngược lại số nguyên thành chuỗi để in ra màn hình
    

    ; Chuyển đổi kết quả thành chuỗi và lưu vào res
    mov rsi, res            ; Địa chỉ lưu trữ kết quả dưới dạng chuỗi
    mov rbx, rax            ; Lưu giá trị kết quả vào rbx
    xor rcx, rcx            ; Xóa rcx (sẽ dùng để đếm số chữ số)

.convert_to_string:
    xor rdx, rdx            ; Xóa rdx (sẽ chứa phần dư)
    mov rdi, 10             ; Chia kết quả cho 10
    div rdi                 ; rax = thương, rdx = phần dư
    add dl, '0'             ; Chuyển đổi phần dư thành ký tự ASCII
    mov [rsi + rcx], dl     ; Lưu ký tự vào chuỗi kết quả
    inc rcx                 ; Tăng rcx (độ dài của chuỗi)
    test rax, rax           ; Kiểm tra nếu thương là 0
    jnz .convert_to_string  ; Nếu là 0 thì tiếp tục chuyển đổi

    
    mov byte [rsi + rcx], 0 ; Kết thúc chuỗi bằng ký tự null

    ; Đảo ngược chuỗi trong res để có được kết quả đúng vì phần này thực hiện việc đảo ngược chuỗi ký tự
    ; chứa kết quả, bởi vì kết quả của phép chuyển đổi số thành chuỗi được lưu trong thứ tự ngược.

    mov rbx, rsi            ; rbx trỏ đến đầu chuỗi
    add rbx, rcx            ; rbx trỏ đến cuối chuỗi (trước ký tự null)
    dec rbx                 ; Lùi rbx để trỏ đến ký tự cuối cùng
    mov rsi, res            ; rsi trỏ đến đầu chuỗi

.reverse_string:
    cmp rsi, rbx            ; So sánh con trỏ đầu (rsi) và cuối (rbx)
    jge .done_reversing     ; Nếu rsi >= rbx, kết thúc đảo ngược
    mov al, [rsi]           ; Nếu rsi < rbx, lấy ký tự tại vị trí rsi
    mov dl, [rbx]           ; Lấy ký tự tại vị trí rbx
    mov [rsi], dl           ; Đổi vị trí ký tự từ rbx về rsi
    mov [rbx], al           ; Đổi vị trí ký tự từ rsi về rbx
    inc rsi                 ; Tăng rsi để trỏ đến ký tự tiếp theo
    dec rbx                 ; Giảm rbx để trỏ về ký tự trước đó
    jmp .reverse_string     ; Lặp lại quá trình

.done_reversing:
    ; In ra kết quả
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msg3
    mov rdx, len3
    syscall

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, res
    mov rdx, rcx           ; Sử dụng rcx để xác định độ dài chuỗi
    syscall

    ; Thoát chương trình
    mov rax, SYS_EXIT       ; Gọi syscall 'exit'
    xor rdi, rdi            ; Trả về mã kết thúc 0
    syscall

print_error:
    ; Hiển thị thông báo lỗi khi nhập không hợp lệ được phát hiện
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    ; Thoát chương trình với mã lỗi
    mov rax, SYS_EXIT
    mov rdi, 1
    syscall

validate_input:
    ; Kiểm tra đầu vào để đảm bảo chỉ có ký tự số
    mov rsi, num1           ; Địa chỉ của chuỗi đầu vào
    xor rax, rax            ; Đặt rax về 0

.validate_loop:
    movzx rcx, byte [rsi]    ; Lấy từng ký tự trong chuỗi
    cmp rcx, 0xA             ; So sánh với ký tự newline (kết thúc đầu vào)
    je .done_validation      ; Nếu gặp newline, hoàn tất kiểm tra
    cmp rcx, '0'             ; Kiểm tra ký tự có nhỏ hơn '0' không
    jb .invalid_input        ; Nếu có, đầu vào không hợp lệ
    cmp rcx, '9'             ; Kiểm tra ký tự có lớn hơn '9' không
    ja .invalid_input        ; Nếu có, đầu vào không hợp lệ
    inc rsi                  ; Tăng con trỏ rsi để lấy ký tự tiếp theo
    jmp .validate_loop       ; Lặp lại quá trình

.done_validation:
    mov rax, 1              ; Đầu vào hợp lệ, trả về 1
    ret

.invalid_input:
    mov rax, 0              ; Đầu vào không hợp lệ, trả về 0
    ret
