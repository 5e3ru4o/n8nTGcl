FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git python3 build-base

# Установка n8n
RUN npm install -g n8n

# Создание директории для пользовательских узлов
RUN mkdir -p /root/.n8n/custom

# Копирование пользовательских узлов
WORKDIR /app
COPY packages/custom-nodes/n8n-nodes-telegram-client /root/.n8n/custom/n8n-nodes-telegram-client

# Установка и сборка пользовательских узлов
WORKDIR /root/.n8n/custom/n8n-nodes-telegram-client

# Изменение ссылок на GitHub в package.json
RUN sed -i 's|"github:ofekb/n8n-nodes-telegram-client"|"*"|g' package.json && \
    sed -i 's|"url": "https://github.com/ofekb/n8n-nodes-telegram-client.git"|"url": "https://example.com"|g' package.json && \
    sed -i 's|"homepage": "https://github.com/ofekb/n8n-nodes-telegram-client"|"homepage": "https://example.com"|g' package.json

# Установка зависимостей и сборка
RUN npm install && npm run build

# Установка рабочей директории
WORKDIR /app

# Использование переменной окружения PORT для Railway
ENV PORT=5678
ENV N8N_PORT=$PORT
ENV NODE_ENV=production
ENV N8N_METRICS=false
ENV N8N_DIAGNOSTICS=false
ENV N8N_USER_FOLDER=/root/.n8n

# Экспозиция порта
EXPOSE $PORT

# Запуск n8n
CMD ["n8n", "start"]
