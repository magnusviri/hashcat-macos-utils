# hashcat macos utils

Oh glorious day. Someone forgot their password and it was the only account with a SecureToken and it gave me the excuse to crack it and in the process come up with these scripts so I can do this so much easier in the future.

## mask-gen.py

Creates a bruteforce mask.hcmask for a 8-9 length character password with 5-7 lowercase letters, 0-2 upper case letters, 0-2 digits, and 1-2 special characters.

```
./mask-gen.py
hashcat -m 7100 hash.txt -a 3 masks.hcmask
```

## dslocal-plist-ShadowHashData-2hashcat.sh

Create a user named "crackme" with a stupid simple password, read it, crack it (ya know, make sure hashcat is working).

```
sysadminctl -addUser crackme -password 1234
./dslocal-plist-ShadowHashData-2hashcat.sh crackme
hashcat -m 7100 hash.txt -a 3 "?d?d?d?d"
hashcat -m 7100 hash.txt -a 3 "?d?d?d?d" --show
```

This is what it looks like.

```
# sysadminctl -addUser crackme -password 1234
2026-05-13 12:01:05.842 sysadminctl[41185:17113773] ----------------------------
2026-05-13 12:01:05.842 sysadminctl[41185:17113773] No clear text password or interactive option was specified (adduser, change/reset password will not allow user to use FDE) !
2026-05-13 12:01:05.842 sysadminctl[41185:17113773] ----------------------------
2026-05-13 12:01:06.140 sysadminctl[41185:17113773] Creating user record…
2026-05-13 12:01:06.767 sysadminctl[41185:17113773] Assigning UID: 506 GID: 20
2026-05-13 12:01:07.618 sysadminctl[41185:17113773] Creating home directory at /Users/crackme
# ./read-shadowhash.sh crackme
[*] Reading ShadowHashData for user: crackme
[*] Raw ShadowHashData (base64, truncated):
    YnBsaXN0MDDSAQIDCl8QHlNSUC1SRkM1MDU0LTQwOTYtU0hBNTEyLVBCS0RGMl8QFFNBTFRFRC1TSEE1...

[*] Decoding ShadowHashData to XML plist...
[*] Decoded plist:
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>SALTED-SHA512-PBKDF2</key>
    	<dict>
    		<key>entropy</key>
    		<data>
    		j8K+vgGvUBJIVMU5WJydnkAv5OIvS3y6IcFQSUg4+h9e1EmozJORkomnuXxl
    		ivLWsi9GGKW5DiySajv63p/nkOfuuPoozWtCw+YYkqdUDr9IkmHPcCILgtnV
    		712A8ojPlx+YY7Sk9pvKfZv4hP9SXE6tGtywljaXPo2aqByacw8=
    		</data>
    		<key>iterations</key>
    		<integer>121951</integer>
    		<key>salt</key>
    		<data>
    		f9/EJGUU7bfdmBFIMP+oWRUNxb/UrL1zYJCJaXFuUUc=
    		</data>
    	</dict>
    	<key>SRP-RFC5054-4096-SHA512-PBKDF2</key>
    	<dict>
    		<key>iterations</key>
    		<integer>136986</integer>
    		<key>salt</key>
    		<data>
    		rOxjBxJWQCM6v2JQ7f42kMWwDO/3WB7b/2yfqvpI380=
    		</data>
    		<key>verifier</key>
    		<data>
    		gNTQKYIUOTla5nnUrKy37ASnKIQD291fI5mk5xOtoVexO4dDhuTk17OPhXkv
    		WCNl9lhW4EdNY95US4L6asV7y02dZCXOk+ggQ9ZPahO1fcPAKuHczSximHSg
    		KBaFH0e4mofLorFhu2wd6WGTKlYS/Sk9UgWCxil24rKGoS5JKkHOVNNUCWyX
    		1dx4cNMLg6L/9pnyl05YNfIzmpAaoDRCM344Smq3uXE/J6qckX5hp12uGHyz
    		+ULWJNiSpYMGCi5XgJhEsTH+C/jJ1dwT4DMjdP723MwdN2H8Iu4pEcBGRM3k
    		mZoFQb0Zq/8LLfjdqJg8SP5lX1HNkn1CjKEss2uvdTh/BB1R61oFMoHBda+S
    		MVbRWt04ckkaYDFRIx7Yq+FyAxqs1izXqw0yjTATPLC/TZcu1yEVPyJj/HRE
    		xG28amEnpMe/qdfkuj9jY/2S9SC9nzY3RNFHfez/JijADStsyTrP5AfK8ySY
    		ZZX22zHjqNzzkjutq+QshtbyTcgtAUc6mV7P4TRCJkH2DOEXHR/VF3yUygMi
    		IY9qVHo3Ksdblw6lU+uA/0Xxdq3OzFO0TbpTMQegMEDn0N43bZLmhs0FfeZz
    		EDftk538z4rQ1mwB909VTpCOe1lLe9h3v1F8cviY3PM5xs3nlWNWBtgUuJHJ
    		WTdEFT1t3I4eJyhJZRQKn+U=
    		</data>
    	</dict>
    </dict>
    </plist>

[*] Extracting salt, entropy, and iterations...
[+] Entropy (base64): j8K+vgGvUBJIVMU5WJydnkAv5OIvS3y6IcFQSUg4+h9e1EmozJORkomnuXxlivLWsi9GGKW5DiySajv63p/nkOfuuPoozWtCw+YYkqdUDr9IkmHPcCILgtnV712A8ojPlx+YY7Sk9pvKfZv4hP9SXE6tGtywljaXPo2aqByacw8=
[+] Salt    (base64): f9/EJGUU7bfdmBFIMP+oWRUNxb/UrL1zYJCJaXFuUUc=
[+] Iterations:       121951

[*] Converting salt and entropy from base64 to hex...
[+] Salt    (hex): 7fdfc4246514edb7dd98114830ffa859150dc5bfd4acbd7360908969716e5147
[+] Entropy (hex): 8fc2bebe01af50124854c539589c9d9e402fe4e22f4b7cba21c150494838fa1f5ed449a8cc93919289a7b97c658af2d6b22f4618a5b90e2c926a3bfade9fe790e7eeb8fa28cd6b42c3e61892a7540ebf489261cf70220b82d9d5ef5d80f288cf971f9863b4a4f69bca7d9bf884ff525c4ead1adcb09636973e8d9aa81c9a730f

[+] Done! Hash written to hash.txt
[+] Hash line:
    $ml$121951$7fdfc4246514edb7dd98114830ffa859150dc5bfd4acbd7360908969716e5147$8fc2bebe01af50124854c539589c9d9e402fe4e22f4b7cba21c150494838fa1f5ed449a8cc93919289a7b97c658af2d6b22f4618a5b90e2c926a3bfade9fe790e7eeb8fa28cd6b42c3e61892a7540ebf489261cf70220b82d9d5ef5d80f288cf971f9863b4a4f69bca7d9bf884ff525c4ead1adcb09636973e8d9aa81c9a730f

[*] Use hashcat mode -m 7100 (macOS PBKDF2-SHA512)
    Example: hashcat -m 7100 hash.txt wordlist.txt
# hashcat -m 7100 hash.txt -a 3 "?d?d?d?d"
hashcat (v7.1.2) starting

METAL API (Metal 372.16)
========================
* Device #01: Apple M4 Pro, skipped

OpenCL API (OpenCL 1.2 (Feb 21 2026 17:15:10)) - Platform #1 [Apple]
====================================================================
* Device #02: Apple M4 Pro, GPU, 19169/38338 MB (3594 MB allocatable), 20MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256
Minimum salt length supported by kernel: 0
Maximum salt length supported by kernel: 256

Hashes: 3 digests; 3 unique digests, 3 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates

Optimizers applied:
* Zero-Byte
* Brute-Force
* Slow-Hash-SIMD-LOOP
* Uses-64-Bit

Watchdog: Temperature abort trigger set to 100c

INFO: Removed 2 hashes found as potfile entries.

Host memory allocated for this attack: 1169 MB (13793 MB free)

The wordlist or mask that you are using is too small.
This means that hashcat cannot use the full parallel power of your device(s).
Hashcat is expecting at least 148480 base words but only got 0.7% of that.
Unless you supply more work, your cracking speed will drop.
For tips on supplying more work, see: https://hashcat.net/faq/morework

Approaching final keyspace - workload adjusted.

$ml$121951$7fdfc4246514edb7dd98114830ffa859150dc5bfd4acbd7360908969716e5147$8fc2bebe01af50124854c539589c9d9e402fe4e22f4b7cba21c150494838fa1f5ed449a8cc93919289a7b97c658af2d6b22f4618a5b90e2c926a3bfade9fe790e7eeb8fa28cd6b42c3e61892a7540ebf489261cf70220b82d9d5ef5d80f288cf971f9863b4a4f69bca7d9bf884ff525c4ead1adcb09636973e8d9aa81c9a730f:1234

Session..........: hashcat
Status...........: Cracked
Hash.Mode........: 7100 (macOS v10.8+ (PBKDF2-SHA512))
Hash.Target......: hash.txt
Time.Started.....: Wed May 13 12:01:36 2026 (7 secs)
Time.Estimated...: Wed May 13 12:01:43 2026 (0 secs)
Kernel.Feature...: Pure Kernel (password length 0-256 bytes)
Guess.Mask.......: ?d?d?d?d [4]
Guess.Queue......: 1/1 (100.00%)
Speed.#02........:      147 H/s (0.67ms) @ Accel:29 Loops:512 Thr:256 Vec:1
Recovered........: 3/3 (100.00%) Digests (total), 1/3 (33.33%) Digests (new), 3/3 (100.00%) Salts
Progress.........: 1000/30000 (3.33%)
Rejected.........: 0/1000 (0.00%)
Restore.Point....: 0/1000 (0.00%)
Restore.Sub.#02..: Salt:0 Amplifier:0-1 Iteration:121856-121950
Candidate.Engine.: Device Generator
Candidates.#02...: 1234 -> 1764
Hardware.Mon.SMC.: Fan0: 50%, Fan1: 54%
Hardware.Mon.#02.: Util: 99% Pwr:14264mW

Started: Wed May 13 12:01:22 2026
Stopped: Wed May 13 12:01:45 2026
# hashcat -m 7100 hash.txt -a 3 "?d?d?d?d" --show
$ml$121951$7fdfc4246514edb7dd98114830ffa859150dc5bfd4acbd7360908969716e5147$8fc2bebe01af50124854c539589c9d9e402fe4e22f4b7cba21c150494838fa1f5ed449a8cc93919289a7b97c658af2d6b22f4618a5b90e2c926a3bfade9fe790e7eeb8fa28cd6b42c3e61892a7540ebf489261cf70220b82d9d5ef5d80f288cf971f9863b4a4f69bca7d9bf884ff525c4ead1adcb09636973e8d9aa81c9a730f:1234

```
