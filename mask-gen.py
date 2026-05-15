#!/usr/bin/env python

from itertools import permutations

ZERO  = (0,)
ZERO_TO_ONE   = (0, 1)
ZERO_TO_TWO   = (0, 1, 2)
ZERO_TO_THREE = (0, 1, 2, 3)
ZERO_TO_FOUR  = (0, 1, 2, 3, 4)
ZERO_TO_FIVE  = (0, 1, 2, 3, 4, 5)
ZERO_TO_SIX   = (0, 1, 2, 3, 4, 5, 6)
ZERO_TO_SEVEN = (0, 1, 2, 3, 4, 5, 6, 7)
ZERO_TO_EIGHT = (0, 1, 2, 3, 4, 5, 6, 7, 8)
ZERO_TO_NINE  = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)

LOWERCASE_COUNTS = ZERO_TO_EIGHT
UPPERCASE_COUNTS = ZERO_TO_ONE
DIGIT_COUNTS     = ZERO_TO_ONE
SPECIAL_COUNTS   = ZERO
TOTAL_LENGTHS    = (8,)

masks = set()

for total_len in TOTAL_LENGTHS:
    for l in LOWERCASE_COUNTS:
        for u in UPPERCASE_COUNTS:
            for d in DIGIT_COUNTS:
                for s in SPECIAL_COUNTS:
                    if l + u + d + s == total_len:
                        pattern = ["?l"] * l + ["?u"] * u + ["?d"] * d + ["?s"] * s
                        print(pattern)
                        for p in set(permutations(pattern)):
                            masks.add("".join(p))

with open("masks.hcmask", "w") as f:
    for mask in sorted(masks, key=lambda x: (len(x), x)):
        f.write(mask + "\n")

print(f"Generated {len(masks)} masks")