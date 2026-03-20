#!/data/data/com.termux/files/usr/bin/bash

# ========== CONFIG ==========
PHP_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/Php/php"
PHAR_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/PocketMine-MP/PocketMine-MP.phar"
PMMP_SH_URL="https://raw.githubusercontent.com/GizCraft/PocketMine-MP-2.0.0-Termux/refs/heads/main/pmmp.sh"

# PHP akan diinstall di direktori saat ini
CURRENT_DIR="$(pwd)"
PHP_PATH="$CURRENT_DIR/php"
BIN="/data/data/com.termux/files/usr/bin"

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

size() {
  curl -sI "$1" | grep -i Content-Length | awk '{print $2}' | tr -d '\r'
}

human() {
  b=$1
  echo $(awk "BEGIN {
    split(\"B KB MB GB\",u)
    for(i=1; b>=1024 && i<4; i++) b/=1024
    printf \"%.2f %s\", b, u[i]
  }")
}

# progress download
download() {
  url=$1
  out=$2

  echo -e "${C}Downloading...${W}"
  curl -L --progress-bar "$url" -o "$out"
}

# ========== CHECK ==========
line
echo -e "${C}CHECK INSTALLATION...${W}"

PHP_EXIST=0
PHAR_EXIST=0

# Cek PHP di direktori saat ini
if [ -f "$PHP_PATH" ]; then
  PHP_EXIST=1
  echo -e "${G}✓ PHP ditemukan di: $PHP_PATH${W}"
fi

# Cek PHAR PocketMine
if [ -f "./PocketMine-MP.phar" ] || \
   [ -f "./src/pocketmine/PocketMine.php" ] || \
   [ -f "./src/PocketMine/PocketMine.php" ]; then
  PHAR_EXIST=1
  echo -e "${G}✓ PocketMine ditemukan${W}"
fi

# ========== INSTALL PHP ==========
if [ $PHP_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PHP belum terinstall di direktori saat ini${W}"
  echo -e "${C}PHP akan diinstall ke: $PHP_PATH${W}"

  SZ=$(size "$PHP_URL")
  echo -e "${C}Ukuran PHP: $(human $SZ)${W}"

  if ask "Install PHP ke direktori saat ini? (y/n) "; then
    download "$PHP_URL" "$PHP_PATH"
    chmod +x "$PHP_PATH"
    echo -e "${G}✔ PHP berhasil diinstall ke: $PHP_PATH${W}"
    
    # Verifikasi PHP
    if [ -f "$PHP_PATH" ]; then
      echo -e "${G}✓ PHP binary ready (ARM64 support)${W}"
      PHP_EXIST=1
    else
      echo -e "${R}✗ Gagal menginstall PHP${W}"
    fi
  else
    echo -e "${R}Batal install PHP${W}"
    exit 1
  fi
else
  echo -e "${G}✓ PHP sudah terinstall di direktori saat ini${W}"
fi

# ========== INSTALL PHAR ==========
if [ $PHAR_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PocketMine-MP belum terinstall${W}"

  SZ=$(size "$PHAR_URL")
  echo -e "${C}Ukuran PHAR: $(human $SZ)${W}"

  if ask "Install PocketMine-MP.phar? (y/n) "; then
    download "$PHAR_URL" "./PocketMine-MP.phar"
    
    if [ -f "./PocketMine-MP.phar" ]; then
      echo -e "${G}✔ PocketMine-MP.phar berhasil diinstall${W}"
      PHAR_EXIST=1
    else
      echo -e "${R}✗ Gagal menginstall PocketMine-MP.phar${W}"
    fi
  else
    echo -e "${R}Batal install PocketMine-MP.phar${W}"
  fi
else
  echo -e "${G}✓ PocketMine-MP sudah terinstall${W}"
fi

# ========== INSTALL PMMP COMMAND ==========
if [ $PHP_EXIST -eq 1 ] && [ $PHAR_EXIST -eq 1 ]; then
  line
  echo -e "${C}Menginstall command 'pmmp'...${W}"

  download "$PMMP_SH_URL" "$BIN/pmmp"
  chmod +x "$BIN/pmmp"
  
  # Modifikasi pmmp.sh untuk menggunakan PHP dari direktori saat ini
  sed -i "s|php|$PHP_PATH|g" "$BIN/pmmp"
  
  echo -e "${G}✔ Command 'pmmp' terinstall${W}"
  echo -e "${C}Gunakan 'pmmp' untuk menjalankan server${W}"
else
  echo -e "${R}✗ Tidak dapat menginstall command karena PHP atau PocketMine-MP belum terinstall${W}"
fi

line
echo -e "${G}========================================${W}"
echo -e "${G}✔ Proses selesai!${W}"
echo -e "${C}PHP terinstall di: $PHP_PATH${W}"
echo -e "${C}PocketMine-MP.phar terinstall di: $(pwd)/PocketMine-MP.phar${W}"

if [ -f "$BIN/pmmp" ]; then
  echo -e "${C}Command: pmmp${W}"
fi
echo -e "${G}========================================${W}"
