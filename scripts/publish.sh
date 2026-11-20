#!/usr/bin/env bash
# Pubblica le modifiche: salva su Git, invia a GitHub, il sito si aggiorna da solo.
#
# Uso:  bash scripts/publish.sh "cosa hai cambiato"
#       bash scripts/publish.sh            (messaggio automatico con la data)
set -euo pipefail

cd "$(dirname "$0")/.."

MSG="${1:-}"
SITE="https://matteomaccari.github.io/"
BRANCH_ATTESO=main

die() { printf '\nERRORE: %b\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "Git non è installato."

git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || die "Questa cartella non è un repository Git. Apri la cartella giusta in VS Code."

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[ "$BRANCH" = "$BRANCH_ATTESO" ] \
  || die "Sei sul ramo '$BRANCH' invece di '$BRANCH_ATTESO'. Non pubblico: chiedi aiuto."

# --- niente da fare?
if [ -z "$(git status --porcelain)" ]; then
  echo "Nessuna modifica da pubblicare: il sito è già aggiornato."
  exit 0
fi

echo "Modifiche che sto per pubblicare:"
git status --short
echo ""

git add -A

# --- avviso per file molto pesanti (rallentano il sito per chi lo visita)
while IFS= read -r f; do
  [ -f "$f" ] || continue
  size=$(wc -c <"$f" | tr -d ' ')
  if [ "$size" -gt 10485760 ]; then
    echo "ATTENZIONE: '$f' pesa $((size / 1048576)) MB."
    echo "            Meglio ridurre le immagini prima di pubblicare."
    echo ""
  fi
done < <(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$MSG" ]; then
  MSG="aggiornamento sito $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$MSG"

echo ""
echo "Invio a GitHub..."
if ! git push origin "$BRANCH_ATTESO"; then
  echo ""
  echo "Qualcuno ha modificato il sito nel frattempo. Unisco le sue modifiche..."
  if ! git pull --rebase --autostash origin "$BRANCH_ATTESO"; then
    # torna indietro: niente file mezzi sistemati a mano
    git rebase --abort >/dev/null 2>&1 || true
    die "Un'altra persona ha modificato le stesse righe.\n       Non ho pubblicato niente e non ho perso il tuo lavoro.\n       Non toccare i file: chiedi aiuto per mettere insieme le due versioni."
  fi
  git push origin "$BRANCH_ATTESO" \
    || die "Invio non riuscito. Controlla la connessione e l'accesso a GitHub."
fi

echo ""
echo "=============================================="
echo " Pubblicato. Il sito si aggiorna entro 1 minuto:"
echo "   $SITE"
echo "=============================================="
