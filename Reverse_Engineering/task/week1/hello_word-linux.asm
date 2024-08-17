;code on linux-32bit by Cyman

section .data               ; khai báo dữ liệu khởi tạo, hằng
    msg         db      'Hello wordl!', 0
    len_msg     equ $ - msg ;độ dài chuỗi

section .text               ;nơi thực thi dòng lệnh
    global _start           ;khai báo nơi chương trình

_start:                     ;cho biết điểm đầu vào của chương trình
    mov     edx,    len_msg ;gán địa chỉ của độ dài chuỗi vào edx
    mov     ecx,    msg     ;gán địa chỉ của chuỗi vào ecx
    mov     ebx,    1       ;file mô tả (1 ~ stdout)
    mov     eax,    4       ;gọi hệ thống (4 ~ sys_write) 
    int     80h             ;gọi kernel để ngắt
    
    mov     eax,    1       ;gọi hệ thống (1 ~ sts_exit)
    int 80h
