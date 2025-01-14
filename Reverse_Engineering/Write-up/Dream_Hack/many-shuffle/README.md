# many-shuffle (Level 2)

>**Link: [chall](https://github.com/anpm2/Cybersecurity/tree/26e7becc5796b9e0a02c5b3ae9a1bf01b5e2be6b/Reverse_Engineering/Write-up/Dream_Hack/many-shuffle/chall)**

* Load chall vào IDA:
```c
__int64 __fastcall main(__int64 a1, char **a2, char **a3)
{
  unsigned int v3; // eax
  size_t v4; // rax
  int i; // [rsp+1Ch] [rbp-A4h]
  int j; // [rsp+20h] [rbp-A0h]
  int k; // [rsp+24h] [rbp-9Ch]
  char *lineptr; // [rsp+28h] [rbp-98h] BYREF
  size_t n; // [rsp+30h] [rbp-90h] BYREF
  FILE *stream; // [rsp+38h] [rbp-88h]
  char original[64]; // [rsp+40h] [rbp-80h] BYREF
  char shuffled[32]; // [rsp+80h] [rbp-40h] BYREF
  char input[24]; // [rsp+A0h] [rbp-20h] BYREF
  unsigned __int64 v15; // [rsp+B8h] [rbp-8h]

  v15 = __readfsqword(0x28u);
  sub_1664(a1, a2, a3);
  v3 = time(0LL);
  srand(v3);
  for ( i = 0; i <= 15; ++i )
    original[i] = rand() % 26 + 65;
  original[16] = 0;
  puts("Random String Generated! Now Shuffle...");
  v4 = strlen(original);
  strncpy(shuffled, original, v4);
  for ( j = 0; j <= 15; ++j )
  {
    for ( k = 0; k <= 15; ++k )
    {
      if ( (j & 1) != 0 )
        shuffled[map[16 * j + k]] = original[k + 32];
      else
        original[map[16 * j + k] + 32] = shuffled[k];
    }
  }
  printf("Shuffled String: %s\n", shuffled);
  printf("Original String?: ");
  fgets(input, 18, stdin);
  input[strcspn(input, "\n")] = 0;
  if ( !strcmp(original, input) )
  {
    lineptr = 0LL;
    n = 0LL;
    stream = fopen("./flag", "r");
    getline(&lineptr, &n, stream);
    printf("Match! Here's your flag: %s", lineptr);
    free(lineptr);
    fclose(stream);
  }
  else
  {
    puts("Wrong...");
  }
  return 0LL;
}
```

* Chương trình tạo 1 chuỗi `original` 16 ký tự ngẫu nhiên sau đó trộn các ký tự của chuỗi original dựa trên mảng map và lưu chuỗi đã trộn vào mảng `shuffled`. 

* Sau đó yêu cầu user nhập lại chuỗi `original` và so sánh. 

* Nếu khớp chương trình sẽ đọc file flag và xuất.

![0](https://github.com/anpm2/Cybersecurity/blob/7cb8d74d28d60239732f271f4301eb4ffc3c12db/Reverse_Engineering/Write-up/Dream_Hack/many-shuffle/image/0.png)
* Khi run và debug thì chương trình chỉ cho 10s để nhập vì thế ta sẽ viết script tự động đọc và gửi chuỗi original.

```python
from pwn import *

map = [0x0B, 0x08, 0x03, 0x04, 0x01, 0x00, 0x0E, 0x0D, 0x0F, 0x09, 0x0C, 0x06, 0x02, 0x05, 0x07, 0x0A, 
       0x0F, 0x04, 0x08, 0x0B, 0x06, 0x07, 0x0D, 0x02, 0x0C, 0x03, 0x05, 0x0E, 0x0A, 0x00, 0x01, 0x09, 
       0x04, 0x0C, 0x0E, 0x05, 0x0D, 0x06, 0x09, 0x0A, 0x01, 0x00, 0x0B, 0x0F, 0x02, 0x07, 0x03, 0x08, 
       0x0A, 0x08, 0x0F, 0x03, 0x04, 0x06, 0x00, 0x0B, 0x01, 0x0D, 0x09, 0x07, 0x05, 0x02, 0x0C, 0x0E, 
       0x0B, 0x06, 0x09, 0x0F, 0x02, 0x01, 0x0A, 0x0E, 0x03, 0x0C, 0x0D, 0x00, 0x05, 0x04, 0x08, 0x07, 
       0x09, 0x04, 0x0B, 0x05, 0x06, 0x0F, 0x08, 0x00, 0x03, 0x01, 0x0A, 0x0D, 0x02, 0x0E, 0x0C, 0x07, 
       0x0A, 0x0E, 0x09, 0x07, 0x08, 0x0D, 0x03, 0x0B, 0x0C, 0x0F, 0x02, 0x00, 0x04, 0x05, 0x06, 0x01, 
       0x05, 0x04, 0x0D, 0x01, 0x00, 0x02, 0x09, 0x0B, 0x0C, 0x07, 0x08, 0x0A, 0x06, 0x0E, 0x0F, 0x03, 
       0x04, 0x08, 0x05, 0x02, 0x0A, 0x0F, 0x0B, 0x07, 0x00, 0x01, 0x0C, 0x03, 0x0E, 0x06, 0x09, 0x0D, 
       0x0D, 0x0E, 0x0F, 0x0B, 0x00, 0x02, 0x0A, 0x04, 0x07, 0x06, 0x09, 0x01, 0x05, 0x03, 0x08, 0x0C,
       0x0E, 0x02, 0x03, 0x05, 0x0A, 0x01, 0x07, 0x00, 0x09, 0x0D, 0x0C, 0x0B, 0x04, 0x06, 0x0F, 0x08, 
       0x03, 0x0B, 0x0E, 0x0A, 0x06, 0x04, 0x07, 0x01, 0x02, 0x0D, 0x0F, 0x00, 0x0C, 0x09, 0x05, 0x08, 
       0x0D, 0x0F, 0x01, 0x02, 0x0C, 0x0A, 0x03, 0x07, 0x09, 0x06, 0x08, 0x05, 0x00, 0x04, 0x0B, 0x0E, 
       0x00, 0x0E, 0x04, 0x0D, 0x06, 0x01, 0x0A, 0x05, 0x03, 0x0C, 0x07, 0x0B, 0x0F, 0x02, 0x08, 0x09, 
       0x0B, 0x02, 0x08, 0x07, 0x05, 0x03, 0x09, 0x0D, 0x04, 0x0F, 0x00, 0x01, 0x06, 0x0C, 0x0E, 0x0A, 
       0x0B, 0x01, 0x08, 0x00, 0x0C, 0x0D, 0x04, 0x0E, 0x0A, 0x06, 0x0F, 0x07, 0x09, 0x05, 0x03, 0x02]

def find_original(shuffled):
    original = [''] * 64

    for j in range(15, -1, -1):
        for k in range(15, -1, -1):
            if (j & 1) != 0:
                original[k + 32] = shuffled[map[16 * j + k]]
            else:
                shuffled[k] = original[map[16 * j + k] + 32]

    return shuffled[:16]# Trả về chuỗi gốc ban đầu

# host = "host1.dreamhack.games"
# port = 16452
# p = remote(host, port)

p = process('./many-shuffle')

context.log_level = 'debug'

p.recvuntil('Shuffled String: ')
data = bytearray(p.recv(16))

payloadd = find_original(data)
p.sendline(payloadd)

response = p.recvall()
print(response)

p.close()
```

![1](https://github.com/anpm2/Cybersecurity/blob/7cb8d74d28d60239732f271f4301eb4ffc3c12db/Reverse_Engineering/Write-up/Dream_Hack/many-shuffle/image/1.png)
* Chạy local thì chính xác rồi, bây giờ thì chạy và gửi payload lên server lấy flag thui!!

<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  DH{7db43cb3498cbe8f2fa1416975bbdca04da997cddf20177be2d141edc2abc23c}
  ```

</details>

![2](https://github.com/anpm2/Cybersecurity/blob/7cb8d74d28d60239732f271f4301eb4ffc3c12db/Reverse_Engineering/Write-up/Dream_Hack/many-shuffle/image/2.png)
