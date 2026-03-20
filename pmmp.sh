#!/data/data/com.termux/files/usr/bin/bash

PREFIX="/data/data/com.termux/files/usr"
PHP="$PREFIX/bin/php"
SESSION="pmmp"

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[0m'

line(){ echo -e "${C}========================================${W}"; }

find_core() {
  if [ -f "./src/pocketmine/PocketMine.php" ]; then
    echo "./src/pocketmine/PocketMine.php"
    return
  fi

  if [ -f "./src/pocketmine/Pocketmine.php" ]; then
    echo "./src/pocketmine/Pocketmine.php"
    return
  fi

  if [ -f "./PocketMine-MP.phar" ]; then
    echo "./PocketMine-MP.phar"
    return
  fi

  echo ""
}

run_server() {
  CORE=$(find_core)

  if [ -z "$CORE" ]; then
    echo -e "${R}✘ Core tidak ditemukan${W}"
    exit 1
  fi

  if tmux has-session -t $SESSION 2>/dev/null; then
    echo -e "${Y}Server sudah berjalan${W}"
    exit 0
  fi

  echo -e "${C}Menjalankan server...${W}"

  if [[ "$CORE" == *.phar ]]; then
    CMD="$PHP $CORE --enable-ansi --no-wizard"
  else
    CMD="$PHP $CORE"
  fi

  tmux new-session -d -s $SESSION "$CMD"

  echo -e "${G}✔ Server dijalankan (session: $SESSION)${W}"
}

status_server() {
  if tmux has-session -t $SESSION 2>/dev/null; then
    echo -e "${G}✔ Server ONLINE${W}"
  else
    echo -e "${R}✘ Server OFFLINE${W}"
  fi
}

stop_server() {
  if tmux has-session -t $SESSION 2>/dev/null; then
    tmux send-keys -t $SESSION "stop" C-m
    sleep 2
    tmux kill-session -t $SESSION 2>/dev/null
    echo -e "${G}✔ Server dihentikan${W}"
  else
    echo -e "${R}Server tidak berjalan${W}"
  fi
}

console_server() {
  if tmux has-session -t $SESSION 2>/dev/null; then
    tmux attach -t $SESSION
  else
    echo -e "${R}Server tidak berjalan${W}"
  fi
}

restart_server() {
  stop_server
  sleep 1
  run_server
}

help_menu() {
  line
  echo -e "${G}PMMP COMMAND${W}"
  line
  echo -e "${C}pmmp${W}              : Jalankan server"
  echo -e "${C}pmmp start${W}        : Jalankan server"
  echo -e "${C}pmmp stop${W}         : Hentikan server"
  echo -e "${C}pmmp restart${W}      : Restart server"
  echo -e "${C}pmmp status${W}       : Status server"
  echo -e "${C}pmmp console${W}      : Masuk console"
  echo -e "${C}pmmp kill${W}         : Paksa matikan server"
  echo -e "${C}pmmp logs${W}         : Lihat log (tmux attach)"
  echo -e "${C}pmmp help${W}         : Bantuan"
  line
  echo -e "${Y}Contoh:${W}"
  echo -e "  pmmp start"
  echo -e "  pmmp stop"
  echo -e "  pmmp console"
  line
}

kill_server() {
  if tmux has-session -t $SESSION 2>/dev/null; then
    tmux kill-session -t $SESSION
    echo -e "${G}✔ Server dimatikan paksa${W}"
  else
    echo -e "${R}Server tidak berjalan${W}"
  fi
}

# ========== MAIN ==========
case "$1" in
  start|"")
    run_server
  ;;
  stop)
    stop_server
  ;;
  restart)
    restart_server
  ;;
  status)
    status_server
  ;;
  console)
    console_server
  ;;
  logs)
    console_server
  ;;
  kill)
    kill_server
  ;;
  -h|--h|-help|--help|help|\?)
    help_menu
  ;;
  *)
    echo -e "${R}Command tidak dikenal${W}"
    help_menu
  ;;
esac
