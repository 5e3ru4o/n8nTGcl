// Скрипт для проверки структуры пакета n8n-nodes-telegram-client
const fs = require('fs');
const path = require('path');

// Путь к директории с пользовательскими узлами
const customDir = '/root/.n8n/custom';
const packageDir = path.join(customDir, 'node_modules', 'n8n-nodes-telegram-client');

console.log('Проверка структуры пакета n8n-nodes-telegram-client');
console.log('=============================================');

// Проверяем существование директории
if (fs.existsSync(packageDir)) {
  console.log(`Директория пакета найдена: ${packageDir}`);
  
  // Получаем список файлов в директории
  const files = fs.readdirSync(packageDir);
  console.log('Файлы в директории пакета:');
  files.forEach(file => {
    console.log(` - ${file}`);
  });
  
  // Проверяем package.json
  const packageJsonPath = path.join(packageDir, 'package.json');
  if (fs.existsSync(packageJsonPath)) {
    const packageJson = require(packageJsonPath);
    console.log('Содержимое package.json:');
    console.log(JSON.stringify(packageJson, null, 2));
    
    // Проверяем n8n поля в package.json
    if (packageJson.n8n) {
      console.log('Найдены настройки n8n в package.json:');
      console.log(JSON.stringify(packageJson.n8n, null, 2));
    } else {
      console.log('ОШИБКА: В package.json отсутствует секция n8n');
    }
  } else {
    console.log('ОШИБКА: Файл package.json не найден');
  }
  
  // Проверяем наличие узлов
  const nodesDir = path.join(packageDir, 'nodes');
  if (fs.existsSync(nodesDir)) {
    console.log(`Директория с узлами найдена: ${nodesDir}`);
    const nodeFiles = fs.readdirSync(nodesDir);
    console.log('Файлы узлов:');
    nodeFiles.forEach(file => {
      console.log(` - ${file}`);
    });
  } else {
    console.log('ОШИБКА: Директория с узлами не найдена');
  }
} else {
  console.log(`ОШИБКА: Директория пакета не найдена: ${packageDir}`);
}

// Проверяем переменные окружения
console.log('Переменные окружения:');
console.log(` - N8N_CUSTOM_EXTENSIONS: ${process.env.N8N_CUSTOM_EXTENSIONS}`);
