/**
 * Скрипт для создания инструмента (tool) в n8n для отправки личных сообщений через Telegram
 */

function telegramUserAgent(input) {
  // Анализируем команду
  let command = input.command || "";
  let user = input.user || "";
  let message = input.message || "";
  
  // Базовая проверка параметров
  if (!command) {
    return { 
      error: true, 
      message: "Не указана команда. Доступные команды: send_message, get_contacts" 
    };
  }
  
  // Обрабатываем разные команды
  if (command === "send_message") {
    if (!user || !message) {
      return { 
        error: true, 
        message: "Для отправки сообщения необходимо указать пользователя (user) и текст сообщения (message)" 
      };
    }
    
    // Формируем HTTP запрос к нашему API
    const options = {
      method: "POST",
      url: "http://localhost:9503/api/send_message",
      headers: {
        "Content-Type": "application/json"
      },
      body: {
        peer: user, // имя пользователя или ID чата
        message: message
      },
      json: true
    };
    
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
