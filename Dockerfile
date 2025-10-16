FROM n8nio/n8n:latest
COPY start-n8n.sh /usr/local/bin/start-n8n.sh
COPY --chmod=0755 start-n8n.sh /usr/local/bin/start-n8n.sh
COPY --chmod=0755 register-telegram-webhook.sh /usr/local/bin/register-telegram-webhook.sh

# Use the shared entrypoint which maps PORT -> N8N_PORT and finds the n8n binary
ENTRYPOINT ["/usr/local/bin/start-n8n.sh"]
CMD ["n8n", "start"]
