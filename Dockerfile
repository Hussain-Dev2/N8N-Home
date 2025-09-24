FROM n8nio/n8n:latest

# نثبت الأدوات اللازمة و Telegram node
USER root
RUN apk add --no-cache ffmpeg
RUN npm install n8n-nodes-telegram --unsafe-perm
USER node
