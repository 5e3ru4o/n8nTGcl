FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git python3 build-base curl

# Установка n8n
RUN npm install -g n8n

# Создание директорий
# Для telegram-api-server
RUN mkdir -p /opt/telegram-api-server/telegram-data
# Для workflow
RUN mkdir -p /root/.n8n/workflows
# Создаем пустую директорию custom, чтобы избежать ошибок
RUN mkdir -p /root/.n8n/custom

# Использование переменной окружения PORT для Railway
ENV PORT=5678
ENV N8N_PORT=$PORT
ENV NODE_ENV=production
ENV N8N_METRICS=false
ENV N8N_DIAGNOSTICS=false
ENV N8N_USER_FOLDER=/root/.n8n
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false
ENV N8N_RUNNERS_ENABLED=true

# Экспозиция порта
EXPOSE $PORT

# Создаем файл telegramUserAgent.js
WORKDIR /root/.n8n/workflows
COPY telegramUserAgent.js /root/.n8n/workflows/telegramUserAgent.js

# Создаем файл для запуска telegram-api-server
WORKDIR /opt/telegram-api-server
RUN echo 'version: "3"\n\nservices:\n  telegram-api-server:\n    image: telegrammtproto/telegram-api-server:latest\n    container_name: telegram-api-server\n    restart: unless-stopped\n    ports:\n      - "127.0.0.1:9503:9503"\n    volumes:\n      - ./telegram-data:/data\n    environment:\n      - API_ID=${API_ID:-12345}\n      - API_HASH=${API_HASH:-abcdefg}' > docker-compose.yml

# Создаем скрипт запуска
WORKDIR /app
RUN echo '#!/bin/sh\n\n# Проверяем содержимое директорий\necho "\n\n=== Содержимое директории /root/.n8n/workflows ==="\nls -la /root/.n8n/workflows\n\necho "\n\n=== Содержимое директории /opt/telegram-api-server ==="\nls -la /opt/telegram-api-server\n\n# Запускаем n8n\necho "\n\n=== Запуск n8n ==="\nn8n start\n' > start.sh
RUN chmod +x start.sh

# Запуск n8n
CMD ["/app/start.sh"]
