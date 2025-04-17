// Скрипт для создания инструмента (tool) в n8n для отправки личных сообщений через Telegram

// Для новых версий n8n нужно использовать эту структуру кода

// Получаем входные данные из предыдущего узла
const items = $input.all();

// Обрабатываем каждый элемент
const returnItems = [];

for (const item of items) {
  // Анализируем команду
  let command = item.json.command || "";
  let user = item.json.user || "";
  let message = item.json.message || "";
  
  let result = {};
  
  // Базовая проверка параметров
  if (!command) {
    result = { 
      error: true, 
      message: "Не указана команда. Доступные команды: send_message, get_contacts" 
    };
  }
  
  // Обрабатываем разные команды
  else if (command === "send_message") {
    if (!user || !message) {
      result = { 
        error: true, 
        message: "Для отправки сообщения необходимо указать пользователя (user) и текст сообщения (message)" 
      };
    } else {
      // Формируем HTTP запрос к нашему API
      try {
        const response = $http.post(
          "http://localhost:9503/api/send_message",
          {
            peer: user,
            message: message
          },
          {
            headers: {
              "Content-Type": "application/json"
            }
          }
        );
        
        result = {
          success: true,
          message: `Сообщение успешно отправлено пользователю ${user}`,
          response: response
        };
      } catch (error) {
        result = {
          error: true,
          message: `Ошибка при отправке сообщения: ${error.message}`
        };
      }
    }
  }
    
    try {
      // Выполняем запрос
      const response = $http.call(options);
      
      return {
        success: true,
        message: `Сообщение успешно отправлено пользователю ${user}`,
        response: response
      };
    } catch (error) {
      return {
        error: true,
        message: `Ошибка при отправке сообщения: ${error.message}`
      };
    }
  } 
  else if (command === "get_contacts") {
    // Формируем HTTP запрос для получения списка контактов
    const options = {
      method: "GET",
      url: "http://localhost:9503/api/contacts",
      headers: {
        "Content-Type": "application/json"
      },
      json: true
    };
    
    try {
      // Выполняем запрос
      const response = $http.call(options);
      
      return {
        success: true,
        contacts: response.contacts || [],
        message: "Список контактов успешно получен"
      };
    } catch (error) {
      return {
        error: true,
        message: `Ошибка при получении списка контактов: ${error.message}`
      };
    }
  }
  else {
    return {
      error: true,
      message: `Неизвестная команда: ${command}. Доступные команды: send_message, get_contacts`
    };
  }
}

module.exports = telegramUserAgent;
