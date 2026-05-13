# dslocal-plist-ShadowHashData-2hashcat.sh
Script that reads a file in /var/db/dslocal/nodes/Default/users/ and creates/appends to hash.txt ready to be input into hashcat.

```
./dslocal-plist-ShadowHashData-2hashcat.sh crackme
hashcat -m 7100 hash.txt -a 3 "?d?d?d?d"
hashcat -m 7100 hash.txt -a 3 "?d?d?d?d" --show
```
