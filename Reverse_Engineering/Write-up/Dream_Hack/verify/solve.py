# flag = 'DH{aaaaaaaa-aaaaaaaaaa-aaaaaaaaaa-aaaaaaaa}'
# print(len(flag))

from z3 import *

def solve_flag():
    # Tạo các biến symbolic cho 4 block của flag
    # 8-10-10-8
    v1 = BitVec('v1', 64)   # fourth block
    v2 = BitVec('v2', 64)   # third block
    v3 = BitVec('v3', 64)   # second block
    v4 = BitVec('v4', 64)   # first block

    solver = Solver()

    solver.add(v3 + v4 == 0xA255CEA0BA)
    solver.add(v3 + v2 == 0xC4259FEEE3)
    solver.add(v2 + v1 == 0x2284419047)
    solver.add(v4 + v1 == 3027255838)
    solver.add(v1 ^ v2 ^ v3 == 0x8391639987)

    if solver.check() == sat:
        m = solver.model()
        
        # Convert to hex
        v1_val = m[v1].as_long()
        v2_val = m[v2].as_long()
        v3_val = m[v3].as_long()
        v4_val = m[v4].as_long()

        print(f"First block (v4): {v4_val:08x}")
        print(f"Second block (v3): {v3_val:010x}")
        print(f"Third block (v2): {v2_val:010x}")
        print(f"Fourth block (v1): {v1_val:08x}")
        print(f"\nDH{{{v4_val:08x}-{v3_val:010x}-{v2_val:010x}-{v1_val:08x}}}")
        
    else:
        print("Not found")

solve_flag()
# Flag: DH{62f0aaba-a1f2ddf600-2232c1f8e3-517f9764}
