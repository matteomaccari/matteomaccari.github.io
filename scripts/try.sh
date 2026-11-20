#!/usr/bin/env bash
# Anteprima del sito sul tuo computer.
#
# Uso:  bash scripts/try.sh
#
# Apre il browser su http://127.0.0.1:<porta> e resta in ascolto.
# Non pubblica niente: le modifiche restano solo sul tuo computer.
# Per fermare: Ctrl+C in questa finestra.
set -euo pipefail

cd "$(dirname "$0")/.."

# --- serve un piccolo web server: usiamo Python, gia' presente su macOS e Linux
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "ERRORE: Python non è installato, quindi non posso avviare l'anteprima." >&2
  echo "Su macOS e Linux c'è già. Su Windows: https://www.python.org/downloads/" >&2
  exit 1
fi

# --- scegli una porta libera (di solito 8000)
PORT="$("$PY" - <<'PY'
import socket
for p in (8000, 8001, 8002, 0):
    s = socket.socket()
    try:
        s.bind(("127.0.0.1", p))
    except OSError:
        s.close()
        continue
    port = s.getsockname()[1]
    s.close()
    print(port)
    break
PY
)"

if [ -z "$PORT" ]; then
  echo "ERRORE: non ho trovato una porta libera." >&2
  exit 1
fi

URL="http://127.0.0.1:$PORT/"

echo "=============================================="
echo " Anteprima del sito: $URL"
echo ""
echo " Lascia questa finestra aperta mentre guardi."
echo " Per fermare l'anteprima: Ctrl+C"
echo "=============================================="
echo ""

# apri il browser (se possibile)
case "$(uname -s)" in
  Darwin) (sleep 1; open "$URL") >/dev/null 2>&1 || true & ;;
  Linux)  (sleep 1; xdg-open "$URL") >/dev/null 2>&1 || true & ;;
  *)
    echo "Apri questo link nel browser: $URL"
    ;;
esac

# 127.0.0.1 = solo dal tuo computer, non dalla rete wifi
exec "$PY" -m http.server "$PORT" --bind 127.0.0.1
