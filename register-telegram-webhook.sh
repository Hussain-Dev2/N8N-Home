#!/bin/sh
# register-telegram-webhook.sh
# Registers a Telegram webhook if TELEGRAM_BOT_TOKEN and WEBHOOK_URL are set

set -e

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$WEBHOOK_URL" ]; then
  echo "Skipping Telegram webhook registration: TELEGRAM_BOT_TOKEN or WEBHOOK_URL not set"
  exit 0
fi

echo "Registering Telegram webhook to: $WEBHOOK_URL"

resp=$(curl -sS -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook" \
  -d url="$WEBHOOK_URL" -w "\nHTTP_STATUS:%{http_code}") || true

echo "$resp"

if echo "$resp" | grep -q "HTTP_STATUS:200"; then
  echo "Webhook set successfully"
  exit 0
else
  echo "Failed to set webhook" >&2
  exit 1
fi
#!/bin/sh
# register-telegram-webhook.sh
# Registers the TELEGRAM webhook using TELEGRAM_BOT_TOKEN and WEBHOOK_URL env vars.

set -eu

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${WEBHOOK_URL:-}" ]; then
  echo "[register-telegram-webhook] TELEGRAM_BOT_TOKEN or WEBHOOK_URL not set; skipping webhook registration"
  exit 0
fi

API_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook"

echo "[register-telegram-webhook] Registering webhook: ${WEBHOOK_URL}"

# Use curl if available, otherwise try wget
if command -v curl >/dev/null 2>&1; then
  resp=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" -d "url=${WEBHOOK_URL}") || true
  body=$(echo "$resp" | sed '$d')
  code=$(echo "$resp" | tail -n1)
elif command -v wget >/dev/null 2>&1; then
  body=$(wget -qO- --post-data="url=${WEBHOOK_URL}" "$API_URL" || true)
  code=0
else
  echo "[register-telegram-webhook] neither curl nor wget found; cannot register webhook"
  exit 0
fi

echo "[register-telegram-webhook] Response code: $code"
echo "[register-telegram-webhook] Body: $body"

# optional: fail the container start if registration failed? We won't fail by default.
if [ "$code" != "200" ] && [ "$code" != "0" ]; then
  echo "[register-telegram-webhook] Warning: non-200 response registering webhook"
fi

exit 0
