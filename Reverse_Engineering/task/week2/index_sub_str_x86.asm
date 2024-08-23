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
