FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git python3 build-base curl

# Установка n8n
RUN npm install -g n8n

# Создание директории для telegram-api-server
RUN mkdir -p /opt/telegram-api-server/telegram-data

# Создание директории для workflow
RUN mkdir -p /root/.n8n/workflows

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
RUN echo '\
/**\n * Скрипт для создания инструмента (tool) в n8n для отправки личных сообщений через Telegram\n */\n\nfunction telegramUserAgent(input) {\n  // Анализируем команду\n  let command = input.command || "";\n  let user = input.user || "";\n  let message = input.message || "";\n  \n  // Базовая проверка параметров\n  if (!command) {\n    return { \n      error: true, \n      message: "Не указана команда. Доступные команды: send_message, get_contacts" \n    };\n  }\n  \n  // Обрабатываем разные команды\n  if (command === "send_message") {\n    if (!user || !message) {\n      return { \n        error: true, \n        message: "Для отправки сообщения необходимо указать пользователя (user) и текст сообщения (message)" \n      };\n    }\n    \n    // Формируем HTTP запрос к нашему API\n    const options = {\n      method: "POST",\n      url: "http://localhost:9503/api/send_message",\n      headers: {\n        "Content-Type": "application/json"\n      },\n      body: {\n        peer: user, // имя пользователя или ID чата\n        message: message\n      },\n      json: true\n    };\n    \n    try {\n      // Выполняем запрос\n      const response = $http.call(options);\n      \n      return {\n        success: true,\n        message: `Сообщение успешно отправлено пользователю ${user}`,\n        response: response\n      };\n    } catch (error) {\n      return {\n        error: true,\n        message: `Ошибка при отправке сообщения: ${error.message}`\n      };\n    }\n  } \n  else if (command === "get_contacts") {\n    // Формируем HTTP запрос для получения списка контактов\n    const options = {\n      method: "GET",\n      url: "http://localhost:9503/api/contacts",\n      headers: {\n        "Content-Type": "application/json"\n      },\n      json: true\n    };\n    \n    try {\n      // Выполняем запрос\n      const response = $http.call(options);\n      \n      return {\n        success: true,\n        contacts: response.contacts || [],\n        message: "Список контактов успешно получен"\n      };\n    } catch (error) {\n      return {\n        error: true,\n        message: `Ошибка при получении списка контактов: ${error.message}`\n      };\n    }\n  }\n  else {\n    return {\n      error: true,\n      message: `Неизвестная команда: ${command}. Доступные команды: send_message, get_contacts`\n    };\n  }\n}\n\nmodule.exports = telegramUserAgent;\n' > telegramUserAgent.js

# Создаем файл для запуска telegram-api-server
WORKDIR /opt/telegram-api-server
RUN echo '\nversion: \'3\'\n\nservices:\n  telegram-api-server:\n    image: telegrammtproto/telegram-api-server:latest\n    container_name: telegram-api-server\n    restart: unless-stopped\n    ports:\n      - "127.0.0.1:9503:9503"\n    volumes:\n      - ./telegram-data:/data\n    environment:\n      - API_ID=${API_ID:-12345}\n      - API_HASH=${API_HASH:-abcdefg}\n' > docker-compose.yml

# Создаем скрипт запуска
WORKDIR /app
RUN echo '#!/bin/sh\n\n# Запускаем n8n\nn8n start\n' > start.sh
RUN chmod +x start.sh

# Запуск n8n
CMD ["/app/start.sh"]
