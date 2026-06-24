#!/bin/sh
# start-n8n.sh
# Maps Render's $PORT → N8N_PORT, registers the Telegram webhook, then starts n8n.

# If the platform (e.g. Render) injects $PORT, use it for n8n
if [ -n "${PORT:-}" ]; then
  export N8N_PORT="$PORT"
fi

# Fall back to default port if still unset
if [ -z "${N8N_PORT:-}" ]; then
  export N8N_PORT=5678
fi

# Register Telegram webhook if credentials are present and the script is executable
if [ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${WEBHOOK_URL:-}" ] && [ -x "/usr/local/bin/register-telegram-webhook.sh" ]; then
  echo "[start-n8n] Registering Telegram webhook"
  /usr/local/bin/register-telegram-webhook.sh || echo "[start-n8n] Telegram registration failed (continuing)" >&2
fi

# ── Start n8n ──────────────────────────────────────────────────────────────────

if [ "$#" -eq 0 ]; then
  # No arguments: find n8n and start it
  if command -v n8n >/dev/null 2>&1; then
    exec n8n start
  elif [ -x "/usr/local/bin/n8n" ]; then
    exec /usr/local/bin/n8n start
  elif [ -x "/usr/bin/n8n" ]; then
    exec /usr/bin/n8n start
  elif [ -x "/home/node/.n8n/node_modules/.bin/n8n" ]; then
    exec /home/node/.n8n/node_modules/.bin/n8n start
  else
    echo "Error: n8n binary not found in PATH or common locations." >&2
    echo "PATH=$PATH" >&2
    exit 127
  fi
else
  # Arguments provided: if the first arg is the literal "n8n", resolve it to an absolute path
  if [ "$1" = "n8n" ]; then
    if command -v n8n >/dev/null 2>&1; then
      BINPATH="$(command -v n8n)"
    elif [ -x "/usr/local/bin/n8n" ]; then
      BINPATH="/usr/local/bin/n8n"
    elif [ -x "/usr/bin/n8n" ]; then
      BINPATH="/usr/bin/n8n"
    else
      BINPATH="n8n"
    fi
    shift
    set -- "$BINPATH" "$@"
  fi
  exec "$@"
fi