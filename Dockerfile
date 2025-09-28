FROM n8nio/n8n:latest


# Render بيوفر المتغير PORT أوتوماتيكياً
ENV N8N_PORT=${PORT}
ENV N8N_HOST=n8n-home-enk1.onrender.com
ENV N8N_PROTOCOL=https

EXPOSE ${PORT}

CMD ["n8n", "start"]
