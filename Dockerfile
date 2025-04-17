FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git python3 build-base

# Установка n8n
RUN npm install -g n8n

# Создание директории для пользовательских узлов
RUN mkdir -p /root/.n8n/custom

# Установка Telegram Client из npm
RUN cd /root/.n8n/custom && \
    npm init -y && \
    npm install n8n-nodes-telegram-client@0.1.6

# Установка рабочей директории
WORKDIR /app

# Использование переменной окружения PORT для Railway
ENV PORT=5678
ENV N8N_PORT=$PORT
ENV NODE_ENV=production
ENV N8N_METRICS=false
ENV N8N_DIAGNOSTICS=false
ENV N8N_USER_FOLDER=/root/.n8n
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false

# Экспозиция порта
EXPOSE $PORT

# Запуск n8n
CMD ["n8n", "start"]
