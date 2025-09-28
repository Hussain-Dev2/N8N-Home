FROM n8nio/n8n:latest

# Host & Protocol
ENV N8N_HOST=n8n-home-enk1.onrender.com
ENV N8N_PROTOCOL=https
ENV N8N_PORT=443

# Expose default n8n port
EXPOSE 443

CMD ["n8n", "start"]
