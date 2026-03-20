#!/data/data/com.termux/files/usr/bin/bash

# ========== CONFIG ==========
CURRENT_DIR="$(pwd)"
PHP="$CURRENT_DIR/php"
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
    echo -e "${R}✗ PHP tidak ditemukan di: $PHP${W}"
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
    echo -e "${G}✓ Mendeteksi source PocketMine${W}"
elif [ -f "$PHAR" ]; then
    CORE_PATH="$PHAR"
    echo -e "${G}✓ Mendeteksi PocketMine-MP.phar${W}"
else
    echo -e "${R}✗ PocketMine tidak ditemukan!${W}"
    echo -e "${Y}Pastikan ada file:${W}"
    echo -e "  - $PHAR"
    echo -e "  - $CORE"
    exit 1
fi

# ========== RUN SERVER ==========
line() { echo -e "${C}========================================${W}"; }

line
echo -e "${C}Memulai PocketMine-MP Server...${W}"
echo -e "${C}PHP: $PHP${W}"
echo -e "${C}Core: $CORE_PATH${W}"
line

# Jalankan server
"$PHP" "$CORE_PATH" --enable-ansi --no-wizard
