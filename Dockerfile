FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git python3 build-base

# Установка n8n
RUN npm install -g n8n

# Создание директории для пользовательских узлов
RUN mkdir -p /root/.n8n/custom/nodes
RUN mkdir -p /root/.n8n/custom/images

# Копируем наш собственный узел Telegram Client
WORKDIR /root/.n8n/custom
RUN npm init -y

# Установка рабочей директории
WORKDIR /app

# Использование переменной окружения PORT для Railway
ENV PORT=5678
ENV N8N_PORT=$PORT
ENV NODE_ENV=production
ENV N8N_METRICS=false
ENV N8N_DIAGNOSTICS=false
ENV N8N_USER_FOLDER=/root/.n8n
ENV N8N_CUSTOM_EXTENSIONS=/root/.n8n/custom
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false

# Экспозиция порта
EXPOSE $PORT

# Копируем файлы узла Telegram Client
COPY telegram-client.js /root/.n8n/custom/nodes/
COPY telegram.svg /root/.n8n/custom/images/

# Создаем package.json для нашего узла
RUN echo '{
  "name": "n8n-nodes-custom",
  "version": "1.0.0",
  "description": "Custom nodes for n8n",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": ["n8n", "nodes"],
  "author": "",
  "license": "ISC",
  "n8n": {
    "nodes": ["nodes/telegram-client.js"]
  }
}' > /root/.n8n/custom/package.json

# Запуск n8n
CMD ["sh", "-c", "ls -la /root/.n8n/custom && ls -la /root/.n8n/custom/nodes && cat /root/.n8n/custom/package.json && n8n start"]
