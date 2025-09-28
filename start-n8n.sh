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

# If no command passed, start n8n with default args
if [ "$#" -eq 0 ]; then
  exec n8n start
else
  exec "$@"
fi
