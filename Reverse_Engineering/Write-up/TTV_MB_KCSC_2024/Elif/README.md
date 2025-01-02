## Elif
> **Chall:**
```python
flag = input('Enter your flag: ')
if len(flag) != 49:
    print('Wrong Length!!!')
    exit()
inp = [ord(c) for c in flag]
if inp[30] + inp[44] + inp[16] + inp[38] + inp[47] + inp[7] != 398:
    print('Wrong Flag!!!')
    exit()
elif inp[41] + inp[22] + inp[38] + inp[33] + inp[28] + inp[20] != 451:
    print('Wrong Flag!!!')
    exit()
elif inp[10] + inp[3] + inp[39] + inp[14] + inp[4] + inp[47] != 440:
    print('Wrong Flag!!!')
    exit()
elif inp[2] + inp[12] + inp[45] + inp[4] + inp[42] + inp[30] != 581:
    print('Wrong Flag!!!')
    exit()
elif inp[36] + inp[36] + inp[26] + inp[43] + inp[21] + inp[1] != 587:
    print('Wrong Flag!!!')
    exit()
elif inp[16] + inp[3] + inp[16] + inp[20] + inp[38] + inp[39] != 274:
    print('Wrong Flag!!!')
    exit()
elif inp[28] + inp[39] + inp[18] + inp[38] + inp[47] + inp[8] != 372:
    print('Wrong Flag!!!')
    exit()
elif inp[25] + inp[19] + inp[36] + inp[19] + inp[20] + inp[31] != 470:
    print('Wrong Flag!!!')
    exit()
elif inp[44] + inp[27] + inp[5] + inp[41] + inp[16] + inp[42] != 565:
    print('Wrong Flag!!!')
    exit()
elif inp[46] + inp[35] + inp[8] + inp[1] + inp[4] + inp[47] != 447:
    print('Wrong Flag!!!')
    exit()
elif inp[41] + inp[20] + inp[42] + inp[40] + inp[3] + inp[43] != 503:
    print('Wrong Flag!!!')
    exit()
elif inp[36] + inp[4] + inp[21] + inp[46] + inp[34] + inp[38] != 532:
    print('Wrong Flag!!!')
    exit()
elif inp[43] + inp[45] + inp[3] + inp[45] + inp[3] + inp[17] != 382:
    print('Wrong Flag!!!')
    exit()
elif inp[24] + inp[2] + inp[6] + inp[2] + inp[25] + inp[1] != 490:
    print('Wrong Flag!!!')
    exit()
elif inp[38] + inp[41] + inp[33] + inp[34] + inp[21] + inp[42] != 569:
    print('Wrong Flag!!!')
    exit()
elif inp[17] + inp[38] + inp[1] + inp[15] + inp[46] + inp[35] != 364:
    print('Wrong Flag!!!')
    exit()
elif inp[40] + inp[17] + inp[34] + inp[33] + inp[39] + inp[19] != 398:
    print('Wrong Flag!!!')
    exit()
elif inp[18] + inp[21] + inp[4] + inp[27] + inp[19] + inp[29] != 541:
    print('Wrong Flag!!!')
    exit()
elif inp[30] + inp[34] + inp[42] + inp[26] + inp[18] + inp[47] != 588:
    print('Wrong Flag!!!')
    exit()
elif inp[23] + inp[24] + inp[30] + inp[1] + inp[13] + inp[7] != 471:
    print('Wrong Flag!!!')
    exit()
elif inp[17] + inp[16] + inp[32] + inp[16] + inp[15] + inp[14] != 343:
    print('Wrong Flag!!!')
    exit()
elif inp[30] + inp[10] + inp[24] + inp[3] + inp[40] + inp[3] != 519:
    print('Wrong Flag!!!')
    exit()
elif inp[10] + inp[34] + inp[27] + inp[38] + inp[46] + inp[40] != 480:
    print('Wrong Flag!!!')
    exit()
elif inp[6] + inp[6] + inp[46] + inp[35] + inp[5] + inp[13] != 357:
    print('Wrong Flag!!!')
    exit()
elif inp[18] + inp[16] + inp[5] + inp[6] + inp[12] + inp[32] != 411:
    print('Wrong Flag!!!')
    exit()
elif inp[1] + inp[3] + inp[37] + inp[4] + inp[22] + inp[44] != 514:
    print('Wrong Flag!!!')
    exit()
elif inp[26] + inp[11] + inp[12] + inp[47] + inp[22] + inp[2] != 541:
    print('Wrong Flag!!!')
    exit()
elif inp[32] + inp[32] + inp[18] + inp[34] + inp[31] + inp[37] != 454:
    print('Wrong Flag!!!')
    exit()
elif inp[38] + inp[25] + inp[1] + inp[23] + inp[28] + inp[27] != 403:
    print('Wrong Flag!!!')
    exit()
elif inp[37] + inp[11] + inp[2] + inp[24] + inp[39] + inp[21] != 457:
    print('Wrong Flag!!!')
    exit()
elif inp[21] + inp[4] + inp[3] + inp[11] + inp[42] + inp[2] != 588:
    print('Wrong Flag!!!')
    exit()
elif inp[11] + inp[36] + inp[27] + inp[1] + inp[18] + inp[19] != 549:
    print('Wrong Flag!!!')
    exit()
elif inp[16] + inp[18] + inp[37] + inp[41] + inp[25] + inp[45] != 446:
    print('Wrong Flag!!!')
    exit()
elif inp[19] + inp[19] + inp[18] + inp[8] + inp[25] + inp[14] != 453:
    print('Wrong Flag!!!')
    exit()
elif inp[19] + inp[2] + inp[40] + inp[34] + inp[27] + inp[5] != 461:
    print('Wrong Flag!!!')
    exit()
elif inp[48] + inp[41] + inp[33] + inp[41] + inp[23] + inp[37] != 533:
    print('Wrong Flag!!!')
    exit()
elif inp[45] + inp[9] + inp[8] + inp[32] + inp[4] + inp[26] != 531:
    print('Wrong Flag!!!')
    exit()
elif inp[47] + inp[27] + inp[2] + inp[32] + inp[3] + inp[38] != 393:
    print('Wrong Flag!!!')
    exit()
elif inp[32] + inp[27] + inp[2] + inp[34] + inp[27] + inp[14] != 506:
    print('Wrong Flag!!!')
    exit()
elif inp[24] + inp[14] + inp[39] + inp[20] + inp[3] + inp[17] != 365:
    print('Wrong Flag!!!')
    exit()
elif inp[10] + inp[17] + inp[43] + inp[28] + inp[48] + inp[48] != 565:
    print('Wrong Flag!!!')
    exit()
elif inp[35] + inp[47] + inp[27] + inp[42] + inp[35] + inp[37] != 415:
    print('Wrong Flag!!!')
    exit()
elif inp[10] + inp[37] + inp[37] + inp[44] + inp[21] + inp[15] != 502:
    print('Wrong Flag!!!')
    exit()
elif inp[9] + inp[44] + inp[9] + inp[48] + inp[38] + inp[15] != 600:
    print('Wrong Flag!!!')
    exit()
elif inp[16] + inp[47] + inp[12] + inp[27] + inp[39] + inp[16] != 386:
    print('Wrong Flag!!!')
    exit()
elif inp[2] + inp[37] + inp[32] + inp[41] + inp[9] + inp[13] != 485:
    print('Wrong Flag!!!')
    exit()
elif inp[25] + inp[18] + inp[25] + inp[41] + inp[40] + inp[11] != 566:
    print('Wrong Flag!!!')
    exit()
elif inp[36] + inp[37] + inp[4] + inp[12] + inp[35] + inp[42] != 546:
    print('Wrong Flag!!!')
    exit()
elif inp[45] + inp[32] + inp[12] + inp[19] + inp[16] + inp[3] != 371:
    print('Wrong Flag!!!')
    exit()
print('Correct!!! Here is your flag: ' + flag)
```
![0](https://github.com/anpm2/Cybersecurity/blob/ee2744c0cda881c61c4f4b034382293213d810a1/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Elif/Image/0.png)
* Chall này cho 1 file python thực hiện nhận input từ user (gồm 49 ký tự hợp lệ) và kiểm tra qua rất nhiều `elif` .
* Sử `z3` để lấy flag thui!!

```python
from z3 import *

# Tạo một mảng các biến integer đại diện cho các ký tự của flag
flag = [Int(f'flag[{i}]') for i in range(49)]

# Tạo một solver
s = Solver()

# Điều kiện độ dài của flag
s.add(flag[0] ==75 )
s.add(flag[30] + flag[44] + flag[16] + flag[38] + flag[47] + flag[7] == 398)
s.add(flag[41] + flag[22] + flag[38] + flag[33] + flag[28] + flag[20] == 451)
s.add(flag[10] + flag[3] + flag[39] + flag[14] + flag[4] + flag[47] == 440)
s.add(flag[2] + flag[12] + flag[45] + flag[4] + flag[42] + flag[30] == 581)
s.add(flag[36] + flag[36] + flag[26] + flag[43] + flag[21] + flag[1] == 587)
s.add(flag[16] + flag[3] + flag[16] + flag[20] + flag[38] + flag[39] == 274)
s.add(flag[28] + flag[39] + flag[18] + flag[38] + flag[47] + flag[8] == 372)
s.add(flag[25] + flag[19] + flag[36] + flag[19] + flag[20] + flag[31] == 470)
s.add(flag[44] + flag[27] + flag[5] + flag[41] + flag[16] + flag[42] == 565)
s.add(flag[46] + flag[35] + flag[8] + flag[1] + flag[4] + flag[47] == 447)
s.add(flag[41] + flag[20] + flag[42] + flag[40] + flag[3] + flag[43] == 503)
s.add(flag[36] + flag[4] + flag[21] + flag[46] + flag[34] + flag[38] == 532)
s.add(flag[43] + flag[45] + flag[3] + flag[45] + flag[3] + flag[17] == 382)
s.add(flag[24] + flag[2] + flag[6] + flag[2] + flag[25] + flag[1] == 490)
s.add(flag[38] + flag[41] + flag[33] + flag[34] + flag[21] + flag[42] == 569)
s.add(flag[17] + flag[38] + flag[1] + flag[15] + flag[46] + flag[35] == 364)
s.add(flag[40] + flag[17] + flag[34] + flag[33] + flag[39] + flag[19] == 398)
s.add(flag[18] + flag[21] + flag[4] + flag[27] + flag[19] + flag[29] == 541)
s.add(flag[30] + flag[34] + flag[42] + flag[26] + flag[18] + flag[47] == 588)
s.add(flag[23] + flag[24] + flag[30] + flag[1] + flag[13] + flag[7] == 471)
s.add(flag[17] + flag[16] + flag[32] + flag[16] + flag[15] + flag[14] == 343)
s.add(flag[30] + flag[10] + flag[24] + flag[3] + flag[40] + flag[3] == 519)
s.add(flag[10] + flag[34] + flag[27] + flag[38] + flag[46] + flag[40] == 480)
s.add(flag[6] + flag[6] + flag[46] + flag[35] + flag[5] + flag[13] == 357)
s.add(flag[18] + flag[16] + flag[5] + flag[6] + flag[12] + flag[32] == 411)
s.add(flag[1] + flag[3] + flag[37] + flag[4] + flag[22] + flag[44] == 514)
s.add(flag[26] + flag[11] + flag[12] + flag[47] + flag[22] + flag[2] == 541)
s.add(flag[32] + flag[32] + flag[18] + flag[34] + flag[31] + flag[37] == 454)
s.add(flag[38] + flag[25] + flag[1] + flag[23] + flag[28] + flag[27] == 403)
s.add(flag[37] + flag[11] + flag[2] + flag[24] + flag[39] + flag[21] == 457)
s.add(flag[21] + flag[4] + flag[3] + flag[11] + flag[42] + flag[2] == 588)
s.add(flag[11] + flag[36] + flag[27] + flag[1] + flag[18] + flag[19] == 549)
s.add(flag[16] + flag[18] + flag[37] + flag[41] + flag[25] + flag[45] == 446)
s.add(flag[19] + flag[19] + flag[18] + flag[8] + flag[25] + flag[14] == 453)
s.add(flag[19] + flag[2] + flag[40] + flag[34] + flag[27] + flag[5] == 461)
s.add(flag[48] + flag[41] + flag[33] + flag[41] + flag[23] + flag[37] == 533)
s.add(flag[45] + flag[9] + flag[8] + flag[32] + flag[4] + flag[26] == 531)
s.add(flag[47] + flag[27] + flag[2] + flag[32] + flag[3] + flag[38] == 393)
s.add(flag[32] + flag[27] + flag[2] + flag[34] + flag[27] + flag[14] == 506)
s.add(flag[24] + flag[14] + flag[39] + flag[20] + flag[3] + flag[17] == 365)
s.add(flag[10] + flag[17] + flag[43] + flag[28] + flag[48] + flag[48] == 565)
s.add(flag[35] + flag[47] + flag[27] + flag[42] + flag[35] + flag[37] == 415)
s.add(flag[10] + flag[37] + flag[37] + flag[44] + flag[21] + flag[15] == 502)
s.add(flag[9] + flag[44] + flag[9] + flag[48] + flag[38] + flag[15] == 600)
s.add(flag[16] + flag[47] + flag[12] + flag[27] + flag[39] + flag[16] == 386)
s.add(flag[2] + flag[37] + flag[32] + flag[41] + flag[9] + flag[13] == 485)
s.add(flag[25] + flag[18] + flag[25] + flag[41] + flag[40] + flag[11] == 566)
s.add(flag[36] + flag[37] + flag[4] + flag[12] + flag[35] + flag[42] == 546)
s.add(flag[45] + flag[32] + flag[12] + flag[19] + flag[16] + flag[3] == 371)

# Ký tự flag là ASCII hợp lệ
for i in range(49):
    s.add(flag[i] >= 32, flag[i] <= 126)

if s.check() == sat:
    m = s.model()
    flag_str = ''
    for char in flag:
        flag_str += chr(m[char].as_long())
    print(f'Flag: {flag_str}')
else:
    print('Not found!')
```

<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  KCSC{700_much_1f-3l53_f0r_fl46ch3ck3r!!!7ry_z3<3}
  ```

</details>

![1](https://github.com/anpm2/Cybersecurity/blob/ee2744c0cda881c61c4f4b034382293213d810a1/Reverse_Engineering/Write-up/TTV_MB_KCSC_2024/Elif/Image/1.png)
