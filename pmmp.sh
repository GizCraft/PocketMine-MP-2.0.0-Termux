#!/data/data/com.termux/files/usr/bin/bash

# ========== COLOR ==========
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

# ========== CEK PHP ==========
if [ ! -f "./php" ]; then
    echo -e "${R}✗ php tidak ditemukan di folder ini${W}"
    exit 1
fi

# ========== CHMOD PHP ==========
if [ ! -x "./php" ]; then
    echo -e "${Y}→ Memberi permission execute...${W}"
    chmod +x ./php
    echo -e "${G}✓ Selesai${W}"
fi

# ========== CEK POCKETMINE ==========
if [ -f "./src/pocketmine/PocketMine.php" ]; then
    CORE="./src/pocketmine/PocketMine.php"
    echo -e "${G}✓ Mode: Source${W}"
elif [ -f "./PocketMine-MP.phar" ]; then
    CORE="./PocketMine-MP.phar"
    echo -e "${G}✓ Mode: PHAR${W}"
else
    echo -e "${R}✗ PocketMine tidak ditemukan${W}"
    exit 1
fi

# ========== JALANKAN ==========
echo -e "${C}========================================${W}"
echo -e "${C}Menjalankan PocketMine-MP...${W}"
echo -e "${C}========================================${W}"

./php "$CORE" --enable-ansi --no-wizard
