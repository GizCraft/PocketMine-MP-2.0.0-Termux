#!/data/data/com.termux/files/usr/bin/bash

# ========== CONFIG ==========
PHP_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/Php/php"
PHAR_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/PocketMine-MP/PocketMine-MP.phar"
PMMP_SH_URL="https://raw.githubusercontent.com/GizCraft/PocketMine-MP-2.0.0-Termux/refs/heads/main/pmmp.sh"

# ========== COLOR ==========
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

# ========== FUNC ==========
line() { echo -e "${C}========================================${W}"; }

ask() {
  read -p "$(echo -e ${Y}$1${W}) " ans
  case "$ans" in
    y|Y|yes|1) return 0 ;;
    *) return 1 ;;
  esac
}

download() {
  echo -e "${C}Downloading...${W}"
  curl -L --progress-bar "$1" -o "$2"
}

# ========== CHECK EXISTING ==========
line
echo -e "${C}CHECK INSTALLATION...${W}"

PHP_EXIST=0
PMMP_EXIST=0

# Cek PHP
if [ -f "./php" ]; then
  PHP_EXIST=1
  echo -e "${G}✓ PHP sudah ada${W}"
fi

# Cek PocketMine (PHAR atau Source)
if [ -f "./PocketMine-MP.phar" ] || [ -f "./src/pocketmine/PocketMine.php" ]; then
  PMMP_EXIST=1
  echo -e "${G}✓ PocketMine sudah ada${W}"
fi

# Jika semua sudah ada, hapus install.sh dan keluar
if [ $PHP_EXIST -eq 1 ] && [ $PMMP_EXIST -eq 1 ]; then
  echo -e "${G}✓ Semua sudah terinstall${W}"
  echo -e "${Y}Menghapus install.sh...${W}"
  rm -- "$0"
  echo -e "${G}✓ Installasi selesai, install.sh telah dihapus${W}"
  exit 0
fi

# ========== INSTALL PHP ==========
if [ $PHP_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PHP belum terinstall${W}"
  
  if ask "Install PHP? (y/n) "; then
    download "$PHP_URL" "./php"
    chmod +x "./php"
    echo -e "${G}✔ PHP berhasil diinstall${W}"
    PHP_EXIST=1
  else
    echo -e "${R}Batal install PHP${W}"
    exit 1
  fi
fi

# ========== INSTALL POCKETMINE ==========
if [ $PMMP_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PocketMine belum terinstall${W}"
  
  if ask "Install PocketMine-MP.phar? (y/n) "; then
    download "$PHAR_URL" "./PocketMine-MP.phar"
    echo -e "${G}✔ PocketMine-MP.phar berhasil diinstall${W}"
    PMMP_EXIST=1
  else
    echo -e "${R}Batal install PocketMine${W}"
    exit 1
  fi
fi

# ========== INSTALL PMMP COMMAND ==========
if [ $PHP_EXIST -eq 1 ] && [ $PMMP_EXIST -eq 1 ]; then
  line
  echo -e "${C}Menginstall command 'pmmp'...${W}"
  
  download "$PMMP_SH_URL" "/data/data/com.termux/files/usr/bin/pmmp"
  chmod +x "/data/data/com.termux/files/usr/bin/pmmp"
  
  echo -e "${G}✔ Command 'pmmp' terinstall${W}"
  echo -e "${C}Gunakan 'pmmp' untuk menjalankan server${W}"
fi

# ========== SELESAI & HAPUS INSTALL.SH ==========
line
echo -e "${G}========================================${W}"
echo -e "${G}✔ Installasi selesai!${W}"
echo -e "${C}PHP: ./php${W}"
echo -e "${C}PocketMine: ./PocketMine-MP.phar${W}"
echo -e "${C}Command: pmmp${W}"
echo -e "${G}========================================${W}"

# Hapus file install.sh
echo -e "${Y}Menghapus install.sh...${W}"
rm -- "$0"
echo -e "${G}✓ Install.sh telah dihapus${W}"
