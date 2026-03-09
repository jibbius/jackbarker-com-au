#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-4000}"
HOST="0.0.0.0"

echo "Checking for processes already listening on port ${PORT}..."

# Parse listening PIDs from ss output, if any.
PIDS=$(ss -lntp "sport = :${PORT}" 2>/dev/null | grep -o 'pid=[0-9]\+' | cut -d= -f2 | sort -u || true)

if [[ -n "${PIDS}" ]]; then
  for pid in ${PIDS}; do
    cmdline=""
    if [[ -r "/proc/${pid}/cmdline" ]]; then
      cmdline=$(tr '\0' ' ' < "/proc/${pid}/cmdline")
    fi

    if [[ "${cmdline}" == *jekyll* ]]; then
      echo "Stopping existing Jekyll process on port ${PORT}: pid=${pid}"
      kill "${pid}" || true
    else
      echo "Port ${PORT} is used by a non-Jekyll process (pid=${pid})."
      echo "Command: ${cmdline:-unknown}"
      echo "Stop that process or run this script with another port:"
      echo "  ./start_jekyll_wsl.sh 4001"
      exit 1
    fi
  done
  sleep 1
fi

WSL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')

echo
echo "Starting Jekyll for WSL -> Windows browser access"
echo "  Host: ${HOST}"
echo "  Port: ${PORT}"
echo
echo "Open from Windows browser:"
echo "  http://localhost:${PORT}/"
if [[ -n "${WSL_IP}" ]]; then
  echo "Fallback if localhost forwarding fails:"
  echo "  http://${WSL_IP}:${PORT}/"
fi
echo

exec bundle exec jekyll serve --host "${HOST}" --port "${PORT}" --livereload --force_polling
