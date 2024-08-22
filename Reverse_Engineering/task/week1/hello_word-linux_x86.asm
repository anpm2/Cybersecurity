;code on linux_x86 by Cyman

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
