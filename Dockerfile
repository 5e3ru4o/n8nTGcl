FROM node:20-alpine

WORKDIR /app

# Установка зависимостей
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/*/package.json ./packages/
COPY packages/@n8n/*/package.json ./packages/@n8n/

# Установка corepack и pnpm
RUN npm install -g corepack@0.24.1 && corepack enable

# Копирование всего проекта
COPY . .

# Установка зависимостей без проверки файла блокировки
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# Сборка проекта
RUN pnpm build

# Установка пользовательских узлов
RUN mkdir -p /root/.n8n/custom
RUN cp -r /app/packages/custom-nodes/n8n-nodes-telegram-client /root/.n8n/custom/ && \
    cd /root/.n8n/custom/n8n-nodes-telegram-client && \
    npm install && \
    npm run build

# Экспозиция порта
EXPOSE 5678

# Запуск n8n
CMD ["pnpm", "start"]
