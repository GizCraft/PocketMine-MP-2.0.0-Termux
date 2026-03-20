#!/data/data/com.termux/files/usr/bin/bash

# ========== GET SCRIPT LOCATION ==========
# Mendapatkan lokasi sebenarnya dari script ini
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pindah ke direktori script berada
cd "$SCRIPT_DIR"

# ========== CONFIG ==========
CURRENT_DIR="$(pwd)"
PHP="./php"
PHAR="./PocketMine-MP.phar"
CORE="./src/pocketmine/PocketMine.php"

# ========== COLOR ==========
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

# ========== DETECT PHP ==========
if [ ! -f "$PHP" ]; then
    echo -e "${R}✗ PHP tidak ditemukan di: $CURRENT_DIR/php${W}"
    echo -e "${Y}Pastikan file php ada di direktori: $CURRENT_DIR${W}"
    exit 1
fi

# ========== CHMOD PHP ==========
if [ ! -x "$PHP" ]; then
    echo -e "${Y}→ Memberikan permission execute pada PHP...${W}"
    chmod +x "$PHP"
    echo -e "${G}✓ PHP permission sudah diperbaiki${W}"
fi

# ========== DETECT CORE ==========
CORE_PATH=""

if [ -f "$CORE" ]; then
    CORE_PATH="$CORE"
    echo -e "${G}✓ Mendeteksi source PocketMine di: $CORE${W}"
elif [ -f "$PHAR" ]; then
    CORE_PATH="$PHAR"
    echo -e "${G}✓ Mendeteksi PocketMine-MP.phar di: $PHAR${W}"
else
    echo -e "${R}✗ PocketMine tidak ditemukan!${W}"
    echo -e "${Y}Pastikan ada salah satu file di direktori: $CURRENT_DIR${W}"
    echo -e "  - $PHAR"
    echo -e "  - $CORE"
    exit 1
fi

# ========== VERIFIKASI PHP BINARY ==========
# Cek apakah PHP binary bisa dijalankan
if ! file "$PHP" | grep -q "ELF"; then
    echo -e "${Y}⚠ PHP binary mungkin corrupt atau bukan binary yang valid${W}"
fi

# ========== RUN SERVER ==========
line() { echo -e "${C}========================================${W}"; }

line
echo -e "${C}Memulai PocketMine-MP Server...${W}"
echo -e "${C}Direktori: $CURRENT_DIR${W}"
echo -e "${C}PHP: ./php${W}"
echo -e "${C}Core: $CORE_PATH${W}"
line

# Jalankan server dengan path relatif
"./php" "$CORE_PATH" --enable-ansi --no-wizard
