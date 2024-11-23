# babycmp (Level 3)

>**Link: [chall](https://github.com/anpm2/Cybersecurity/tree/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Chall)**

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/1.png)
* Chạy file thì thấy nó nhận input và kiểm tra nếu nhập sai thì hiện thông báo như hình, nếu đúng thì có thể là flag cần tìm.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/2.png)
* Bài này sử dụng các hàm API win32 thông báo nhập/xuất và hiển thị ra màn hình,... vì thế ta cần chú ý tìm hàm **WinMain** để bắt đầu khai thác.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/3.png)
* Ban đầu lúc chạy file ta thấy thì nó nhận input từ user vì thế ta chú ý tìm hàm **`GetWindowText`**.
  
* Hàm **`GetWindowText`** trong **Windows API** để lấy văn bản của một cửa sổ.

* Nó nhận vào một _handle_ (con trỏ) đến cửa sổ muốn lấy văn bản, và trả về văn bản đó trong một chuỗi ký tự.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/4.png)
* Hàm **`sub_140001C30`** nhận con trỏ v18 kiểu void chính là input từ người dùng và trả về  1 ký từ đại diện cho kết quả (0 hoặc 1).

* Kiểm tra input và gọi hàm API win32 **MessageBoxW**  để in ra thông báo khi nhập đúng hoặc sai.

* Phân tích hàm **`sub_140001C30`**:

> ![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/5.png)
* Đầu tiên kiểm tra kích thước của chuỗi đầu vào.

* Vì hàm nhận con trỏ **Input** làm đầu vào nên **`Input[2]`** đại diện cho kích thước dữ liệu mà con trỏ **Input** đang trỏ tới.

* Nếu kích thước chuỗi `input != 24` thì hàm sẽ thực hiện thao tác khác mà không qua quá trình mã hoá.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/6.png)
* Đoạn này thực hiện so sánh 3 byte đầu của input với các byte tương ứng trong v23 (3 byte trong v23 gồm `D, H, {`)

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/7.png)
* Hàm tiếp tục kiểm tra byte thứ 24 (vị trí 23) của input có là `}` ko.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/8.png)
* Nếu input hợp lệ thì gọi hàm **`sub_140001A10`** bắt đầu quá trình mã hoá.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/9.png)
* Hàm **`sub_140001A10`** nhận 2 tham số đầu vào là 2 con trỏ **Output** và **Input** và trả về con trỏ **Output** kiểu **QWORD** (8 bytes) đã được mã hoá.

* Đầu tiên hàm thực hiện vòng lặp sao chép dữ liệu từ **Input** vào **Output** chuyển đổi từ kiểu 1 byte (**Char**) sang kiểu 4 byte (**DWORD**).

* Tiếp theo là các thao tác xoay phải 4 bit, XOR và cộng với giá trị key, cuối cùng cộng với 30000 để mã hoá.

![](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/10.png)
* Sau khi **input** đã được mã hoá và gán cho **Output** thì thực hiện so sánh kết quả với mảng **`cipher`**.

* Nếu khớp thì **result** trả về 1 ngược lại trả về 0.

>[solve.py](https://github.com/anpm2/Cybersecurity/blob/ed89e664241bc361d7f47e874b6f9515100da67a/Reverse_Engineering/Write-up/Dream_Hack/babycmp/solve.py)
```python
#Decode by Cyman

cipher = [ 0x08, 0x76, 0x00, 0x40, 0xF6, 0x75, 0x00, 0x80,
           0x07, 0x76, 0x00, 0xB0, 0x07, 0x76, 0x00, 0x90,
           0xFA, 0x75, 0x00, 0x00, 0x04, 0x76, 0x00, 0x50,
           0xFF, 0x75, 0x00, 0xF0, 0x16, 0x76, 0x00, 0x40,
           0x07, 0x76, 0x00, 0x20, 0xFB, 0x75, 0x00, 0x30,
           0x09, 0x76, 0x00, 0xF0, 0x08, 0x76, 0x00, 0x30,
           0xF7, 0x75, 0x00, 0xD0, 0x04, 0x76, 0x00, 0x00,
           0xFF, 0x75, 0x00, 0xF0, 0x10, 0x76, 0x00, 0xF0,
           0x06, 0x76, 0x00, 0xD0, 0xF8, 0x75, 0x00, 0x10,
           0x03, 0x76, 0x00, 0x50, 0x07, 0x76, 0x00, 0x40,
           0xFA, 0x75, 0x00, 0x30, 0x04, 0x76, 0x00, 0x20,
           0xFE, 0x75, 0x00, 0x10, 0x12, 0x76, 0x00, 0xD0 ]

def rol4(n, l):
    return ((n << l) | (n >> (32 - l))) & 0xFFFFFFFF

key = b"neko_hat"
flag = ''
cipher_dword = []

for i in range(0, len(cipher), 4):
    j = (cipher[i + 3] << 24) | (cipher[i + 2] << 16) | (cipher[i + 1] << 8) | cipher[i]
    j &= 0xFFFFFFFF
    cipher_dword.append(j)

for i in range(len(cipher_dword)):
    val = cipher_dword[i]
    val -= 30000
    val -= key[i % 4]
    val ^= key[i % 8]
    val = rol4(val, 4)
    flag += chr(val)

print(f'Flag: {flag}')
```

<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  DH{y0u_4r3_cmp__ma5t3r!}
  ```

</details>

> ![](https://github.com/anpm2/Cybersecurity/blob/278e8a7275f139b8f9caf95eb6bd9b4e1228fe70/Reverse_Engineering/Write-up/Dream_Hack/babycmp/Image/11.png)
