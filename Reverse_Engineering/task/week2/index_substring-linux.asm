; định nghĩa các hằng trong system call 
SYS_EXIT  equ 60
SYS_READ  equ 0    
SYS_WRITE equ 1

; định nghĩa các hằng số sử dụng cho file descriptor trong Linux
STDIN     equ 0     ;file descriptor nhập
STDOUT    equ 1     ;file descriptor xuất

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
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msga
    mov rdx, lena
    syscall

    ; Đọc chuỗi A
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, string_a
    mov rdx, 100
    syscall

    ; Loại bỏ ký tự newline ở cuối chuỗi A
    mov rdi, string_a
    call remove_newline

    ; Yêu cầu người dùng nhập chuỗi B
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msgb
    mov rdx, lenb
    syscall

    ; Đọc chuỗi B
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, substring_b
    mov rdx, 50
    syscall

    ; Loại bỏ ký tự newline ở cuối chuỗi B
    mov rdi, substring_b
    call remove_newline

    ; Gọi hàm tìm substring
    xor rcx, rcx           ; Khởi tạo chỉ số cho chuỗi chính A
    mov rdi, string_a      ; Địa chỉ của chuỗi chính A
    mov rsi, substring_b   ; Địa chỉ của chuỗi con B
    call find_substring

    ; Kiểm tra kết quả
    cmp rax, -1            ; Nếu không tìm thấy (kết quả trả về là -1)
    je  not_found_msg

    ; In kết quả index
    call print_index

    ; Thoát chương trình
    call exit_program

not_found_msg:
    ; In thông báo "Substring not found"
    mov rsi, err
    mov rdx, lenerr
    call print_string
    call exit_program

; Hàm tìm vị trí của substring trong chuỗi
find_substring:
    push rbx               ; Lưu giá trị cũ của rbx
    mov rbx, rdi           ; Lưu địa chỉ của string A vào rbx
    xor rax, rax           ; Đặt index = 0

next_char:
    ; Kiểm tra kết thúc chuỗi A
    cmp byte [rbx + rcx], 0
    je  not_found_return   ; Nếu hết chuỗi mà chưa khớp, trả về -1

    ; So sánh chuỗi con B với chuỗi A từ vị trí hiện tại
    mov rdi, rbx           ; Đặt địa chỉ của chuỗi hiện tại trong A
    add rdi, rcx           ; Dời đến vị trí hiện tại
    mov rsi, substring_b   ; Địa chỉ của chuỗi con B
    call compare_strings

    ; Nếu khớp, trả về chỉ số
    cmp rax, 0
    je  found_match

    ; Tiếp tục tìm
    inc rcx
    jmp next_char

not_found_return:
    mov rax, -1            ; Không tìm thấy
    pop rbx                ; Khôi phục rbx
    ret

found_match:
    mov rax, rcx           ; Đặt chỉ số vào rax
    pop rbx                ; Khôi phục rbx
    ret

; Hàm so sánh chuỗi con với chuỗi chính
compare_strings:
    xor rdx, rdx           ; Dùng rdx như là chỉ số so sánh

compare_loop:
    mov al, [rdi + rdx]
    cmp al, [rsi + rdx]
    jne not_match
    cmp byte [rsi + rdx], 0 ; Nếu chuỗi con đã hết và khớp toàn bộ, báo khớp
    je match
    inc rdx
    jmp compare_loop

not_match:
    mov rax, 1             ; Không khớp
    ret

match:
    xor rax, rax           ; Khớp
    ret

; Hàm loại bỏ ký tự newline ở cuối chuỗi
remove_newline:
    mov rcx, -1
    mov al, 0              ; ký tự kết thúc chuỗi
    mov rbx, rdi

find_newline:
    inc rcx
    cmp byte [rbx + rcx], 0
    je newline_done
    cmp byte [rbx + rcx], 10 ; Kiểm tra ký tự newline (LF)
    jne find_newline

    ; Thay thế newline bằng null
    mov byte [rbx + rcx], al

newline_done:
    ret

; Hàm in chỉ số index
print_index:
    ; Chuyển số thành chuỗi để in
    xor rdx, rdx           ; Xóa rdx
    mov rdi, rax           ; Chỉ số cần in
    mov rcx, 10            ; Cơ số 10
    mov rbx, rsp           ; Lưu vị trí stack hiện tại

convert_loop:
    xor rdx, rdx           ; Xóa rdx
    div rcx                ; Chia rax cho 10
    add dl, '0'            ; Thêm giá trị ASCII của '0'
    dec rbx                ; Dời con trỏ ngăn xếp
    mov [rbx], dl          ; Lưu kết quả vào ngăn xếp
    test rax, rax          ; Kiểm tra rax có bằng 0 không
    jnz convert_loop       ; Nếu không, tiếp tục chia

print_digits:
    mov rsi, rbx           ; Đặt địa chỉ hiện tại trên ngăn xếp
    mov rdx, rsp           ; Lấy địa chỉ của phần cuối của stack
    sub rdx, rbx           ; Tính số ký tự
    mov rax, SYS_WRITE     ; syscall: sys_write
    mov rdi, STDOUT        ; file descriptor: stdout
    syscall
    ret

; Hàm in chuỗi
print_string:
    mov rax, SYS_WRITE     ; syscall: sys_write
    mov rdi, STDOUT        ; file descriptor: stdout
    syscall
    ret

; Hàm thoát chương trình
exit_program:
    mov rax, SYS_EXIT      ; syscall: sys_exit
    xor rdi, rdi           ; mã thoát (0)
    syscall
