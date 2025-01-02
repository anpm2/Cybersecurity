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