![Banner image](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

# n8n с интеграцией Telegram User API

## Интеграция с Telegram User API

Этот проект добавляет в n8n возможность отправлять сообщения через ваш личный аккаунт Telegram (не бота). Интеграция основана на [telegram-user-api](https://github.com/CreatmanCEO/telegram-user-api).

### Быстрый старт / Quick Start

#### 1. Получите API_ID и API_HASH для Telegram
- Перейдите на https://my.telegram.org/auth
- Войдите в свой аккаунт Telegram
- Выберите "API development tools"
- Заполните форму (можно указать любое название приложения)
- Сохраните полученные api_id и api_hash

#### 2. Запустите telegram-user-api через Docker Compose
- Убедитесь, что Docker установлен
- В корне проекта выполните:
  ```sh
  docker-compose up -d
  ```
- Переменные окружения API_ID и API_HASH можно задать в .env файле или прямо в системе.
- Данные Telegram будут храниться в папке `telegram-data`.

#### 3. Добавьте кастомный узел Telegram User в n8n
- После сборки n8n узел появится в редакторе (Telegram User / Пользователь Telegram)
- Создайте креденшлы Telegram User API и укажите ваши API ID, API Hash и URL (обычно http://localhost:9503/api)
- Используйте узел в workflow, выбрав команду (send_message/get_contacts), пользователя и текст сообщения.

---

### English

#### 1. Get your API_ID and API_HASH for Telegram
- Go to https://my.telegram.org/auth
- Log in to your Telegram account
- Select "API development tools"
- Fill in the form (any app name)
- Save your api_id and api_hash

#### 2. Run telegram-user-api via Docker Compose
- Make sure Docker is installed
- In the project root run:
  ```sh
  docker-compose up -d
  ```
- Set API_ID and API_HASH in your .env file or system environment.
- Telegram data will be stored in the `telegram-data` folder.

#### 3. Add the custom Telegram User node to n8n
- After building n8n, the node will appear in the editor (Telegram User)
- Create Telegram User API credentials and enter your API ID, API Hash, and API URL (usually http://localhost:9503/api)
- Use the node in your workflow, select command (send_message/get_contacts), user and message text.

---

### Важно / Important
- Вся интеграция работает через ваш личный Telegram-аккаунт (не бот)
- Не передавайте свои ключи третьим лицам
- Для production рекомендуется использовать HTTPS и ограничить доступ к API

---

### Примеры использования / Usage Examples

### Примеры использования

```javascript
// Отправка сообщения
{
  "command": "send_message",
  "user": "username", // имя пользователя или ID чата
  "message": "Привет! Это сообщение отправлено через n8n."
}

// Получение списка контактов
{
  "command": "get_contacts"
}
```

# n8n - Secure Workflow Automation for Technical Teams

n8n is a workflow automation platform that gives technical teams the flexibility of code with the speed of no-code. With 400+ integrations, native AI capabilities, and a fair-code license, n8n lets you build powerful automations while maintaining full control over your data and deployments.

![n8n.io - Screenshot](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-screenshot-readme.png)

## Key Capabilities

- **Code When You Need It**: Write JavaScript/Python, add npm packages, or use the visual interface
- **AI-Native Platform**: Build AI agent workflows based on LangChain with your own data and models
- **Full Control**: Self-host with our fair-code license or use our [cloud offering](https://app.n8n.cloud/login)
- **Enterprise-Ready**: Advanced permissions, SSO, and air-gapped deployments
- **Active Community**: 400+ integrations and 900+ ready-to-use [templates](https://n8n.io/workflows)

## Quick Start

Try n8n instantly with [npx](https://docs.n8n.io/hosting/installation/npm/) (requires [Node.js](https://nodejs.org/en/)):

```
npx n8n
```

Or deploy with [Docker](https://docs.n8n.io/hosting/installation/docker/):

```
docker volume create n8n_data
docker run -it --rm --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

Access the editor at http://localhost:5678

## Resources

- 📚 [Documentation](https://docs.n8n.io)
- 🔧 [400+ Integrations](https://n8n.io/integrations)
- 💡 [Example Workflows](https://n8n.io/workflows)
- 🤖 [AI & LangChain Guide](https://docs.n8n.io/langchain/)
- 👥 [Community Forum](https://community.n8n.io)
- 📖 [Community Tutorials](https://community.n8n.io/c/tutorials/28)

## Support

Need help? Our community forum is the place to get support and connect with other users:
[community.n8n.io](https://community.n8n.io)

## License

n8n is [fair-code](https://faircode.io) distributed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) and [n8n Enterprise License](https://github.com/n8n-io/n8n/blob/master/LICENSE_EE.md).

- **Source Available**: Always visible source code
- **Self-Hostable**: Deploy anywhere
- **Extensible**: Add your own nodes and functionality

[Enterprise licenses](mailto:license@n8n.io) available for additional features and support.

Additional information about the license model can be found in the [docs](https://docs.n8n.io/reference/license/).

## Contributing

Found a bug 🐛 or have a feature idea ✨? Check our [Contributing Guide](https://github.com/n8n-io/n8n/blob/master/CONTRIBUTING.md) to get started.

## Join the Team

Want to shape the future of automation? Check out our [job posts](https://n8n.io/careers) and join our team!

## What does n8n mean?

**Short answer:** It means "nodemation" and is pronounced as n-eight-n.

**Long answer:** "I get that question quite often (more often than I expected) so I decided it is probably best to answer it here. While looking for a good name for the project with a free domain I realized very quickly that all the good ones I could think of were already taken. So, in the end, I chose nodemation. 'node-' in the sense that it uses a Node-View and that it uses Node.js and '-mation' for 'automation' which is what the project is supposed to help with. However, I did not like how long the name was and I could not imagine writing something that long every time in the CLI. That is when I then ended up on 'n8n'." - **Jan Oberhauser, Founder and CEO, n8n.io**
