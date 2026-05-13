/usr/bin/env python

from itertools import permutations

masks = set()

for total_len in (8, 9):
    for l in range(5, 8):
        for u in range(0, 3):
            for d in range(0, 4):
                for s in range(0, 2):
                    if l + u + d + s == total_len:
                        pattern = ["?l"] * l + ["?u"] * u + ["?d"] * d + ["?s"] * s
                        for p in set(permutations(pattern)):
                            masks.add("".join(p))

with open("masks.hcmask", "w") as f:
    for mask in sorted(masks, key=lambda x: (len(x), x)):
        f.write(mask + "\n")

print(f"Generated {len(masks)} masks")