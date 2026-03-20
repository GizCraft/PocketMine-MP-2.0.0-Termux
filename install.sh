#!/data/data/com.termux/files/usr/bin/bash

# ========== CONFIG ==========
PHP_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/Php/php"
PHAR_URL="https://github.com/GizCraft/PocketMine-MP-2.0.0-Termux/releases/download/PocketMine-MP/PocketMine-MP.phar"
PMMP_SH_URL="https://raw.githubusercontent.com/GizCraft/PocketMine-MP-2.0.0-Termux/refs/heads/main/pmmp.sh"

PREFIX="/data/data/com.termux/files/usr"
BIN="$PREFIX/bin"

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

[ -f "$BIN/php" ] && PHP_EXIST=1

if [ -f "./PocketMine-MP.phar" ] || \
   [ -f "./src/pocketmine/PocketMine.php" ] || \
   [ -f "./src/PocketMine/PocketMine.php" ]; then
  PHAR_EXIST=1
fi

if [ $PHP_EXIST -eq 1 ] && [ $PHAR_EXIST -eq 1 ]; then
  echo -e "${G}✔ Semua sudah terinstall.${W}"
  exit 0
fi

# ========== INSTALL PHP ==========
if [ $PHP_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PHP belum ada${W}"

  SZ=$(size "$PHP_URL")
  echo -e "${C}Ukuran: $(human $SZ)${W}"

  if ask "Install PHP? (y/n)"; then
    download "$PHP_URL" "$BIN/php"
    chmod +x "$BIN/php"
    echo -e "${G}✔ PHP terinstall${W}"
  else
    echo -e "${R}Batal install PHP${W}"
  fi
fi

# ========== INSTALL PHAR ==========
if [ $PHAR_EXIST -eq 0 ]; then
  line
  echo -e "${Y}PocketMine belum ada${W}"

  SZ=$(size "$PHAR_URL")
  echo -e "${C}Ukuran: $(human $SZ)${W}"

  if ask "Install PocketMine-MP.phar? (y/n)"; then
    download "$PHAR_URL" "PocketMine-MP.phar"
    echo -e "${G}✔ PHAR terinstall${W}"
  else
    echo -e "${R}Batal install PHAR${W}"
  fi
fi

# ========== INSTALL PMMP.SH ==========
line
echo -e "${C} Installing Command${W}"

download "$PMMP_SH_URL" "$BIN/pmmp"
chmod +x "$BIN/pmmp"

echo -e "${G}✔ Use 'pmmp' to run server${W}"

line
echo -e "${G}✔ Completed${W}"
