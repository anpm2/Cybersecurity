; code on window 32 bit by Cyman

global _main                ; khai báo main
extern _printf              ; liên kết thư viện chuẩn C bên ngoài

section .data               ; nơi khai báo các biến dữ liệu
msg: db 'Hello world!', 0xa, 0; 0xa (new line), 0 (NULL)

section .text               ; nơi thực thi dòng lệnh
_main:
    push    msg             ; đẩy địa chỉ chuỗi lên stack
    call    _printf         ; gọi và hàm sẽ lấy tham số đầu tiên trong stack để hiển thị chuỗi
    add     esp, 4          ; giải phóng ko gian trên stack vì mỗi address trong x86 là 4 bytes
                            ; tăng esp lên 4 để làm trống stack
    ret                     ; trả về giá trị và kết thúc chương trình
