#!/bin/bash

SCRIPT="/root/rl-swarm/run_rl_swarm.sh"
TMP_LOG="/tmp/rlswarm_stdout.log"
MAX_IDLE=600  # 10 минут

KEYWORDS=(
  "BlockingIOError"
  "EOFError"
  "RuntimeError"
  "ConnectionResetError"
  "CUDA out of memory"
  "P2PDaemonError"
  "OSError"
  "error was detected while running rl-swarm"
  "Connection refused"
  "requests.exceptions.ConnectionError"
)

P2P_ERROR_MSG="P2PDaemonError('Daemon failed to start in 15.0 seconds')"

while true; do
  echo "[$(date)] 🔧 Отключаем удаление JSON..."
  # Вариант: комментируем rm через true&& (без нарушения структуры)
  sed -i '/modal-login\/temp-data\/.*\.json/ s#rm -r#true \&\& rm -r#' "$SCRIPT"

  echo "[$(date)] 🚀 Запускаем Gensyn-ноду..."

  rm -f "$TMP_LOG"
  ( sleep 1 && printf "n\n\n\n" ) | bash "$SCRIPT" 2>&1 | tee "$TMP_LOG" &
  PID=$!

  while kill -0 "$PID" 2>/dev/null; do
    sleep 5

    if [ -f "$TMP_LOG" ]; then
      current_mod=$(stat -c %Y "$TMP_LOG")
      now=$(date +%s)
      idle_time=$((now - current_mod))

      if (( idle_time > MAX_IDLE )); then
        echo "[$(date)] ⚠️ Лог не обновлялся более $((MAX_IDLE/60)) минут. Перезапуск..."
        kill -9 "$PID" 2>/dev/null
        sleep 3
        break
      fi
    fi

    if grep -q "$P2P_ERROR_MSG" "$TMP_LOG"; then
      echo "[$(date)] 🛠 Обнаружена ошибка P2P-демона. Патчим startup_timeout..."

      DAEMON_FILE=$(find ~/rl-swarm/.venv -type f -path "*/site-packages/hivemind/p2p/p2p_daemon.py" 2>/dev/null | head -n 1)

      if [[ -n "$DAEMON_FILE" ]]; then
        echo "[$(date)] ✏️ Патчим файл: $DAEMON_FILE"
        sed -i -E 's/(startup_timeout: *float *= *)15(,?)/\1120\2/' "$DAEMON_FILE"
      else
        echo "[$(date)] ❌ Не найден p2p_daemon.py"
      fi

      kill -9 "$PID" 2>/dev/null
      sleep 3
      break
    fi

    for ERR in "${KEYWORDS[@]}"; do
      if grep -q "$ERR" "$TMP_LOG"; then
        echo "[$(date)] ❌ Найдена ошибка '$ERR'. Перезапуск..."
        kill -9 "$PID" 2>/dev/null
        sleep 3
        break 2
      fi
    done
  done

  echo "[$(date)] 🔁 Перезапуск через 3 секунды..."
  sleep 3
done
