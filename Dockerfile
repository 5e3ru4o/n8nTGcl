FROM docker.n8n.io/n8nio/n8n:latest

# Копирование пользовательских узлов
COPY packages/custom-nodes/n8n-nodes-telegram-client /tmp/n8n-nodes-telegram-client

# Установка пользовательских узлов
USER root
RUN mkdir -p /home/node/.n8n/custom && \
    cp -r /tmp/n8n-nodes-telegram-client /home/node/.n8n/custom/ && \
    cd /home/node/.n8n/custom/n8n-nodes-telegram-client && \
    npm install && \
    npm run build && \
    chown -R node:node /home/node/.n8n

USER node

# Экспозиция порта
EXPOSE 5678
