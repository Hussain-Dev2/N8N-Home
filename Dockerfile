FROM n8nio/n8n:2.27.4

COPY --chmod=0755 start-n8n.sh /usr/local/bin/start-n8n.sh
COPY --chmod=0755 register-telegram-webhook.sh /usr/local/bin/register-telegram-webhook.sh

EXPOSE 5678

# Entrypoint maps $PORT → N8N_PORT and registers the Telegram webhook before starting n8n
ENTRYPOINT ["/usr/local/bin/start-n8n.sh"]
CMD ["n8n", "start"]




 