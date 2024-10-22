# Inject ME!! (Level 1)

>**Link: [chall](https://github.com/anpm2/Cybersecurity/tree/97152bdb2d0db0afdf8ff8ad602dab668cd79927/Reverse_Engineering/Write-up/Dream_Hack/inject_ME/Chall)**

* **Mô tả:** chall này chỉ cho chúng ta duy nhất file có dạng **`.dll`** và yêu cầu lấy được **flag** bằng cách load **dll** theo các điều kiện cho trước.

* Bài này không cho file thực thi mà chỉ cho file **dll**(**DLL** là viết tắt của **Dynamic Link Library**-Thư viện liên kết động). 

* Đây là một loại file chứa các mã lệnh, dữ liệu và tài nguyên mà nhiều chương trình khác nhau có thể sử dụng chung.

* Cách hoạt động cơ bản như sau:
  *  1 chương trình cần sử dụng một chức năng nào đó, nó sẽ tìm kiếm trong các file DLL để tìm mã lệnh tương ứng. 
  *  Nếu tìm thấy, chương trình sẽ tải mã lệnh đó vào bộ nhớ và thực thi. 
  *  Quá trình này được gọi là liên kết động.


![](https://github.com/anpm2/Cybersecurity/blob/97152bdb2d0db0afdf8ff8ad602dab668cd79927/Reverse_Engineering/Write-up/Dream_Hack/inject_ME/Image/1.png)
* Load file vào IDA ta có hàm DllMain như trên.

* Tiến hành đi vào hàm **`sub_1800011A0`** để phân tích.
```c
int sub_1800011A0()
{
  int result; // eax
  unsigned __int64 i; // [rsp+20h] [rbp-2E8h]
  unsigned __int64 j; // [rsp+28h] [rbp-2E0h]
  char *Str1; // [rsp+30h] [rbp-2D8h]
  CHAR Text[4]; // [rsp+78h] [rbp-290h] BYREF
  int v5; // [rsp+7Ch] [rbp-28Ch]
  int v6; // [rsp+80h] [rbp-288h]
  int v7; // [rsp+84h] [rbp-284h]
  int v8; // [rsp+88h] [rbp-280h]
  _DWORD v9[16]; // [rsp+90h] [rbp-278h] BYREF
  CHAR Filename[272]; // [rsp+D0h] [rbp-238h] BYREF
  CHAR pszPath[272]; // [rsp+1E0h] [rbp-128h] BYREF

  GetModuleFileNameA(0LL, Filename, 0x104u);
  Str1 = PathFindFileNameA(Filename);
  result = strncmp(Str1, "dreamhack.exe", 0xDuLL);
  if ( !result )
  {
    memset(v9, 0, sizeof(v9));
    for ( i = 0LL; i < 0x10; ++i )
    {
      GetModuleFileNameA(0LL, pszPath, 0x104u);
      v9[i] = __ROL4__(*(_DWORD *)PathFindFileNameA(pszPath), i);
    }
    sub_180001010(v9);
    for ( j = 0LL; j < 0x64; ++j )
      sub_180001060();
    v5 = 1131317369;
    v6 = 813709630;
    v7 = 2046637516;
    v8 = -183554036;
    *(_DWORD *)Text = sub_180001060() ^ 0x7ED39C88;
    v5 = sub_180001060() ^ 0x436E8879;
    v6 ^= sub_180001060();
    v7 ^= sub_180001060();
    v8 ^= sub_180001060();
    return MessageBoxA(0LL, Text, "flag", 0);
  }
  return result;
}
```
* Phân tích khái quát:
  * Lấy tên file thực thi:
    * GetModuleFileNameA được gọi để lấy tên file đang chạy và lưu vào biến Filename.
    * Hàm PathFindFileNameA trích xuất phần tên file từ đường dẫn đầy đủ.
  * So sánh:
    * Hàm **`strncmp`** so sánh tên file hiện tại với chuỗi **`"dreamhack.exe"`** trong 13 ký tự. 
    * Nếu trùng khớp (hàm trả về 0), mã tiếp theo sẽ được thực thi.
  * Xử lý và mã hoá:
    * Chương trình tiếp tục có thể mã hoá lưu giá trị vào biến **Text**.
  * In ra flag: 
    * Sau khi xử lý và mã hóa, hàm **`MessageBoxA`** được gọi để hiển thị hộp thoại với nội dung là giá trị trong **Text**, với tiêu đề là "**flag**".

* Sau khi phân thì ta rút ra được rằng muốn in ra **flag** ta phải thực thi chương trình có tên là **dreamhack.exe**.

```c
#include <windows.h>
#include <iostream>

int main() {
    // Load prob_rev.dll
    HMODULE hProbRev = LoadLibraryA("prob_rev.dll");
    if (!hProbRev) {
        MessageBoxA(NULL, "Failed to load prob_rev.dll", "Error", MB_OK);
        return 1;
    }
    
    // Giải phóng DLL
    FreeLibrary(hProbRev);
    return 0;
}
```

* Ta sẽ tạo 1 chương trình **`.cpp`** sử dụng hàm **`LoadLibraryA`** để tải thư viện **DLL** có tên **prob_rev.dll**.

* Nếu thành công, biến hProbRev sẽ chứa một con trỏ đến DLL đó và in ra **flag**.

* Ngược lại, (**DLL** không tồn tại hoặc không thể tải), biến **hProbRev** sẽ có giá trị **NULL** và in ra thông báo lỗi.

* **Compile** file **`dreamhack.cpp`** và xuất ra file **dreamhack.exe** để lấy flag.
> Lưu ý phải compile file trong môi trường window.

<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  DH{reng@r_is_cute}
  ```
  
</details>

![](https://github.com/anpm2/Cybersecurity/blob/97152bdb2d0db0afdf8ff8ad602dab668cd79927/Reverse_Engineering/Write-up/Dream_Hack/inject_ME/Image/2.png)
