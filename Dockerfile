FROM n8nio/n8n:latest

# نثبت الأدوات اللازمة و Telegram node
USER root
RUN apk add --no-cache ffmpeg
USER node
