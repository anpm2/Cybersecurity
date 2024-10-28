# Go
>![](https://github.com/anpm2/Cybersecurity/blob/c1af7c1574383f20a06397d766dffbed3835f26d/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/Go-Easy.png)

>**Link:** [chall](https://github.com/anpm2/Cybersecurity/tree/c1af7c1574383f20a06397d766dffbed3835f26d/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Chall)

![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/1.png)
* Như mô tả của chall thì đầy là chương trình được compile bằng ngôn ngữ Go

![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/2.png)
* Chạy thử chall thì nhận được thông tin như hình

![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/3.png)
![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/4.png)
* Mở file bằng IDA và đi đến hàm main

* Nhận thấy chall yêu cầu nhập **flag** và so sánh độ dài **flag** với `33h`==>`51`.

* Nếu không đủ 51 ký tự thì thoát chương trình và thông báo như ban đầu.

* Nếu đúng 51 ký tự thì bắt đầu thực hiện check flag.

```c
for ( i = 0LL; i < 51; i = v14 + 1 )
  {
    ptr = v17->ptr;
    if ( i >= v17->len )
      runtime_panicIndex(i, v8, v17->len, 1LL, 1LL, ptr);
    flag = (unsigned __int8)ptr[i];
    v14 = i;
    v26 = i - (i & 0xFFFFFFFFFFFFFFE0LL);       // v26 = i % 32
    if ( v26 >= 0x20 )
      runtime_panicIndex(v26, v8, 32LL, 1LL, 1LL, v26);
    v15 = "YXV0aG9ybm9vYm1hbm5uZnJvbWtjc2M=";
    v27 = (unsigned __int8)text[v26] ^ flag;
    v13 = *(_QWORD *)&cipher[8 * i - 8];
if ( v13 != v27 )                           // so sánh cipher và giá trị sau khi xor flag với text
    {
      v67 = i;
      v72[0] = &RTYPE_string;
      v72[1] = &off_4DBC10;                     // Wrong Flag!!!
      v8 = os_Stdout;
      fmt_Fprintln(
        (unsigned int)go_itab__os_File_io_Writer,
        os_Stdout,
        (unsigned int)v72,
        1,
        1,
        (unsigned int)&off_4DBC10,
        i,
        (unsigned int)"YXV0aG9ybm9vYm1hbm5uZnJvbWtjc2M=",
        v16,
        v52,
        v58,
        v61,
        v63,
        v65);
      os_Exit(1, v8, v28, 1, 1, v29, v30, v31, v32, v54);
      v17 = p_string;
      v14 = v67;
    }
  }
  v71 = v3;
  v33 = v17->ptr;
  len = v17->len;
  v35 = runtime_concatstring2(
          0,
          (unsigned int)"Correct!! Here is your flag: ",
          29,
          v17->ptr,
          len,
          v13,
          v14,
          (_DWORD)v15,
          v16,
          v52,
          v58,
          v61,
          v63,
          v65);
  v41 = runtime_convTstring(
          v35,
          (unsigned int)"Correct!! Here is your flag: ",
          v36,
          (_DWORD)v33,
          len,
          v37,
          v38,
          v39,
          v40,
          v55,
          v59);
  *(_QWORD *)&v71 = &RTYPE_string;
  *((_QWORD *)&v71 + 1) = v41;
  v42 = os_Stdout;
  fmt_Fprintln(
    (unsigned int)go_itab__os_File_io_Writer,
    os_Stdout,
    (unsigned int)&v71,
    1,
    1,
    v43,
    v44,
    v45,
    v46,
    v56,
    v60,
    v62,
    v64,
    v66);
  os_Exit(1, v42, v47, 1, 1, v48, v49, v50, v51, v57);
```
* Phân tích
  * Chương trình sẽ lấy từng ký tự trong mảng **`text[32] = "YXV0aG9ybm9vYm1hbm5uZnJvbWtjc2M="`** `XOR` với từng ký tự trong **`flag`** nhập vào từ user.

  * Sau đó đem so sánh với từng giá trị trong mảng **`cipher`** nếu sai thì in ra thông báo `Wrong Flag!!!` và ngược lại thì in ra `Correct!! Here is your flag: `.
  ![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/5.png)
  * Ta check thì **`cipher`** hiện tại không có gì vì thế ta sẽ trace xem **`cipher`** biến đổi từ đâu.

  ![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/6.png)
  * Hàm **`loc_45F062`** thực hiện gán giá trị của mảng **`unk_4DD358`** cho **`cipher`**
  
  * Để chắc chắn ta sẽ đặt **breakpoint** ngay dưới hàm **`loc_45F062`** để check.
  
  > ![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/7.png)
  > mảng **`unk_4DD358`**

  > ![](https://github.com/anpm2/Cybersecurity/blob/main/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Go/Image/8.png)
  > mảng **`cipher`**

  * Ta thấy cả 2 giá trị trong mảng **`unk_4DD358`** và mảng **`cipher`** đều như nhau.

  > [solve.py]()
  
```python
cipher =[
  0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x73, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x1A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x57, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x1B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x6E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x7C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x29, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x23, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x6A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x61, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x75, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x5D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x53, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x66, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x6A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x49, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x4C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
  
text = 'YXV0aG9ybm9vYm1hbm5uZnJvbWtjc2M='
length = len(text)
flag = ''

for i in range(51):
    flag += chr(cipher[i * 8] ^ ord(text[i % length]))

print('Flag:', flag)
#Flag: KCSC{7h15_15_345y60l4n6_ch4ll3n63_7ea2da17_<3<3!!!}
```