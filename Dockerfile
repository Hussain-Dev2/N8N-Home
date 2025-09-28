FROM n8nio/n8n:latest

# تثبيت ffmpeg فقط، Telegram Node موجودة ضمن core nodes
USER root
RUN apk add --no-cache ffmpeg
USER node
