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