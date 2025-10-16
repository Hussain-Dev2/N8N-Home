#!/bin/sh
# start-n8n.sh - sets N8N_PORT from Render's $PORT if present and starts n8n

# If Render (or any platform) sets PORT, prefer it for N8N
if [ -n "$PORT" ]; then
  export N8N_PORT="$PORT"
fi

# Ensure default port if not set
if [ -z "$N8N_PORT" ]; then
  export N8N_PORT=5678
fi

# Optional: allow overriding HOST/PROTOCOL via environment variables (keep as-is if not provided)
# If you want defaults, uncomment and set them here.
# : ${N8N_HOST:=example.com}
# : ${N8N_PROTOCOL:=https}

# Register Telegram webhook only if both TELEGRAM_BOT_TOKEN and WEBHOOK_URL are set
if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$WEBHOOK_URL" ] && [ -x "/usr/local/bin/register-telegram-webhook.sh" ]; then
  echo "[start-n8n] Registering Telegram webhook"
  /usr/local/bin/register-telegram-webhook.sh || echo "[start-n8n] Telegram registration failed (continuing)" >&2
fi

# If no command passed, start n8n with default args
if [ "$#" -eq 0 ]; then
  # Try to find n8n in PATH or common install locations and exec it with 'start'
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
  # If the first arg is the literal 'n8n', replace it with an absolute path if needed
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
    # remove the first arg and rebuild args with absolute path first
    shift
    set -- "$BINPATH" "$@"
  fi
  fi
  exec "$@"
fi
