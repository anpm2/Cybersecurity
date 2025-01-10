## s1mple_flag_checker_but_no_see
> **Chall:**
```java
import java.util.*;

public class Flag_Checker {
	static int[] pos = { 10, 15, 19, 28, 30, 44, 49 };
	static int[] f1nal = { 18, 20, 22, 23, 25, 26, 27, 31, 33, 34, 36, 37, 39, 40 };

	public static boolean check_format(boolean ret, String s) {
		if ((!s.substring(0, 5).equals("KCSC{")) || !(s.charAt(s.length() - 1) == '}'))
			ret = false;
		return ret;
	}

	public static boolean check_pos(boolean ret, String s, int[] arr) {
		for (int i = 0; i < arr.length; ++i) {
			if (s.charAt(arr[i]) != 95)
				return false;
		}
		return ret;
	}

	public static boolean check_digit(boolean ret, String s, boolean[] arr) {
		int[] num = new int[10];

		for (int i = 0; i < s.length(); ++i) {
			if (Character.isDigit(s.charAt(i)) != arr[i])
				ret = false;
		}
		for (int i = 0; i < pos.length; ++i) {
			num[i] = s.charAt(pos[i]) - 0x30;
		}
		if ((num[1] != num[6])
				|| (num[0] != num[1] - num[6])
				|| (num[3] + num[4] != num[1])
				|| (num[6] * num[5] != 20)
				|| (num[0] != num[2])
				|| (Math.pow(num[3], num[5]) != 256)
				|| ((num[1] ^ num[4]) != 4)
				|| (num[1] != 5)) {
			ret = false;
		}
		return ret;
	}
	
	public static boolean check_let(boolean ret, String s, char[] arr) {
		int l = 5, r = 55, cnt = 0;
		while (cnt < arr.length) {
			while (!Character.isLetter(s.charAt(l)))
				l++;
			while (!Character.isLetter(s.charAt(r)))
				r--;
			if (s.charAt(r) != arr[cnt] || s.charAt(l) != arr[cnt + 1]) {
				ret = false;
			}
			cnt += 2;
			l++;
			r--;
		}
		return ret;
	}

	public static boolean check(boolean ret, String s, String tmp) {
		for (int i = 0; i < f1nal.length; ++i)
			tmp += s.charAt(f1nal[i]);

		if (((tmp.charAt(2) ^ tmp.charAt(0)) != 32)
				|| (tmp.charAt(0) + tmp.charAt(5) + tmp.charAt(6) != 294)
				|| (tmp.charAt(1) * tmp.charAt(3) != 8160)
				|| ((tmp.charAt(3) ^ tmp.charAt(4)) != 44)
				|| ((tmp.charAt(2) ^ tmp.charAt(3)) != 9)
				|| (tmp.charAt(0) * tmp.charAt(3) != 8058)
				|| (tmp.charAt(3) - tmp.charAt(4) != 28)
				|| ((tmp.charAt(2) ^ tmp.charAt(7)) != 28)
				|| (tmp.charAt(12) - tmp.charAt(13) + tmp.charAt(9) - tmp.charAt(8) != 38)
				|| (tmp.charAt(3) - tmp.charAt(4) != 28)
				|| ((tmp.charAt(2) ^ tmp.charAt(11)) != 0)
				|| (tmp.charAt(4) - tmp.charAt(6) != -44)
				|| ((tmp.charAt(6) ^ tmp.charAt(8)) != 19)
				|| (tmp.charAt(9) - tmp.charAt(5) != 25)
				|| (tmp.charAt(0) + tmp.charAt(5) + tmp.charAt(7) != 291)
				|| ((tmp.charAt(10) ^ tmp.charAt(5)) != 21)
				|| (tmp.charAt(1) != tmp.charAt(13))
				|| (tmp.charAt(11) != 111)
				|| (s.charAt(s.length() - 2) != 63)) {
			ret = false;
		}
		return ret;
	}

	public static void main(String[] args) {
		boolean[] isDigit = { false, false, false, false, false, false, false, false, false, false, true, false,
				false, false, false, true, false, false, false, true, false, false, false, false, false, false, false,
				false, true, false, true, false, false, false, false, false, false, false, false, false, false, false,
				false, false, true, false, false, false, false, true, false, false, false, false, false, false, false };
		int[] pos = { 17, 21, 24, 29, 32, 35, 38, 47, 52 };
		char[] let = { 't', 'P', 'i', 'o', 't', 'L', 'n', 'y', 'i', 'm', 'h', 'r', 'c', 'p', 'o', 'h', 'r', 'i', 'P', 'm' };
		Scanner inp = new Scanner(System.in);
		System.out.print("Enter flag: ");
		String input = inp.next();
		boolean ret = true;
		if (check(check_let(check_pos(check_digit(check_format(ret, input), input, isDigit), input, pos), input, let), input, ""))
			System.out.println("Flag is correct");
		else
			System.out.println("Try another one");
	}
}
```
![]()
* Chall này cho 1 file java yêu cầu nhập **flag** và kiểm tra qua nhiều hàm **`check`** lồng nhau.
* Mình đã đổi tên để dễ nhận biết với các hàm theo thứ tự từ trong ra ngoài là check format của **flag** (`KCSC{...}`), check vị trí của các số (`digit`), check vị trí của dấu `_`, check vị trí của các chữ cái (`let`) trong mảng `let` và cuối cùng là hàm check các chữ cái còn lại trong mảng `f1nal`.
* Sử dụng z3 để lấy flag thui!!
> Note: Khai báo điều kiện là `BitVec` để sử dụng các phép toán xor, or 
```python
from z3 import *

flag = [Int(f'flag[{i}]') for i in range(57)]
s = Solver()

# Check 'KCSC{'
format_flag = 'KCSC{'
for i in range(5):
    s.add(flag[i] == ord(format_flag[i]))
s.add(flag[56] == 0x7D) # ord('}') = 0x7D

# Check pos
pos_ = [17, 21, 24, 29, 32, 35, 38, 47, 52]
for i in pos_:
    s.add(flag[i] == 95)  # ord('_') = 95

# Check digit
pos_digit = [10, 15, 19, 28, 30, 44, 49]
num = [BitVec(f'num[{i}]', 32) for i in range(7)]
n = Solver()

n.add(num[1] == num[6])
n.add(num[0] == num[1] - num[6])
n.add(num[3] + num[4] == num[1])
n.add(num[6] * num[5] == 20)
n.add(num[0] == num[2])
n.add(num[3] == 4)
n.add(num[5] == 4)
n.add(num[4] == 1)
n.add(num[1] == 5)

if n.check() == sat:
    m = n.model()
    for i in range(7):
        s.add(flag[pos_digit[i]] == ord(str(m[num[i]].as_long())))
        # print(m[num[i]].as_long(), end=', ')
else:
    print('\nNot digit!')

# Check f1nal
f1nal = [18, 20, 22, 23, 25, 26, 27, 31, 33, 34, 36, 37, 39, 40]
tmp = [BitVec(f'tmp[{i}]', 8) for i in range(len(f1nal))]
t = Solver()

for i in range(len(f1nal)):
    t.add(32 <= tmp[i], tmp[i] <= 126)

t.add(tmp[0] + tmp[5] + tmp[6] == 294)
t.add((tmp[2] ^ tmp[0]) == 32)
t.add(tmp[0] + tmp[5] + tmp[6] == 294)
t.add(tmp[1] * tmp[3] == 8160)
t.add((tmp[3] ^ tmp[4]) == 44)
t.add((tmp[2] ^ tmp[3]) == 9)
t.add(tmp[0] * tmp[3] == 8058)
t.add(tmp[3] - tmp[4] == 28)
t.add((tmp[2] ^ tmp[7]) == 28)
t.add(tmp[12] - tmp[13] + tmp[9] - tmp[8] == 38)
t.add((tmp[2] ^ tmp[11]) == 0)
t.add(tmp[4] - tmp[6] == -44)
t.add((tmp[6] ^ tmp[8]) == 19)
t.add(tmp[9] - tmp[5] == 25)
t.add(tmp[0] + tmp[5] + tmp[7] == 291)
t.add((tmp[10] ^ tmp[5]) == 21)
t.add(tmp[1] == tmp[13])
t.add(tmp[11] == 111)

if t.check() == sat:
    m = t.model()
    for i in range(len(f1nal)):
        s.add(flag[f1nal[i]] == m[tmp[i]].as_long())
        # print(m[tmp[i]].as_long(), end=', ')
else:
    print('\nNot tmp!')

s.add(flag[55] == 63)

# Check letter
let = ['t', 'P', 'i', 'o', 't', 'L', 'n', 'y', 'i', 'm', 'h', 'r', 'c', 'p', 'o', 'h', 'r', 'i', 'P', 'm']
not_let_pos = sorted(pos_ + pos_digit + f1nal + [55])
# print(not_let_pos)
l, r, cnt = 5, 55, 0
while cnt < len(let):
    while l in not_let_pos:
        l += 1
    while r in not_let_pos:
        r -= 1
    s.add(flag[r] == ord(let[cnt]))
    s.add(flag[l] == ord(let[cnt + 1]))
    cnt += 2
    l += 1
    r -= 1

if s.check() == sat:
    m = s.model()
    res = ''
    for i in range(57):
        res += chr(m[flag[i]].as_long())
    print(f'Flag: {res}')
else:
    print('\nNot found!')
```
<details>
  <summary><strong><code>Flag:</code></strong></summary>
  
  ```
  KCSC{PoLym0rphi5m_O0P_of_Jav4_1s_ez_to_aPPro4ch_i5nt_it?}
  ```

</details>
![0]()

![1]()
