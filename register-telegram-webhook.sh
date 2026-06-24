#!/bin/sh
# register-telegram-webhook.sh
# Registers the Telegram webhook using TELEGRAM_BOT_TOKEN and WEBHOOK_URL env vars.

set -eu

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${WEBHOOK_URL:-}" ]; then
  echo "[register-telegram-webhook] TELEGRAM_BOT_TOKEN or WEBHOOK_URL not set; skipping webhook registration"
  exit 0
fi

API_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook"

echo "[register-telegram-webhook] Registering webhook: ${WEBHOOK_URL}"

if command -v curl >/dev/null 2>&1; then
  # Capture body and HTTP status code separately
  resp=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" -d "url=${WEBHOOK_URL}") || true
  body=$(echo "$resp" | sed '$d')
  code=$(echo "$resp" | tail -n1)
elif command -v wget >/dev/null 2>&1; then
  # wget doesn't expose HTTP status easily; check the response body for success instead
  body=$(wget -qO- --post-data="url=${WEBHOOK_URL}" "$API_URL" 2>/dev/null || true)
  code="wget"
  # Treat an empty body as a failure
  if [ -z "$body" ]; then
    echo "[register-telegram-webhook] Warning: wget returned empty response; webhook may not be registered"
    exit 0
  fi
else
  echo "[register-telegram-webhook] Neither curl nor wget found; cannot register webhook"
  exit 0
fi

echo "[register-telegram-webhook] Response code: $code"
echo "[register-telegram-webhook] Body: $body"

# Verify the Telegram API returned ok:true
if echo "$body" | grep -q '"ok":true'; then
  echo "[register-telegram-webhook] Webhook registered successfully"
else
  echo "[register-telegram-webhook] Warning: Telegram API did not confirm success. Check body above."
fi

exit 0