FROM docker.n8n.io/n8nio/n8n:latest

# Установка необходимых пакетов
USER root
RUN apt-get update && apt-get install -y git python3 build-essential && apt-get clean

# Создание директории для пользовательских узлов
RUN mkdir -p /home/node/.n8n/custom

# Установка Telegram Client из npm
RUN cd /home/node/.n8n/custom && \
    npm init -y && \
    npm install n8n-nodes-telegram-client@0.1.6 && \
    chown -R node:node /home/node/.n8n

# Установка рабочей директории
WORKDIR /app

# Использование переменной окружения PORT для Railway
ENV PORT=5678
ENV N8N_PORT=$PORT
ENV NODE_ENV=production
ENV N8N_METRICS=false
ENV N8N_DIAGNOSTICS=false
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false

# Экспозиция порта
EXPOSE $PORT

# Запуск n8n
CMD ["n8n", "start"]
