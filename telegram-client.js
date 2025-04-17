// Простой узел Telegram Client для n8n
const { NodeOperationError } = require('n8n-workflow');

class TelegramClient {
  constructor() {
    this.id = 'telegramClient';
    this.name = 'Telegram Client';
    this.description = 'Взаимодействие с Telegram через пользовательский аккаунт';
    this.icon = 'file:telegram.svg';
    this.group = ['communication'];
    this.version = 1;
    this.defaults = {
      name: 'Telegram Client',
    };
    this.inputs = ['main'];
    this.outputs = ['main'];
    this.credentials = [
      {
        name: 'telegramClientApi',
        required: true,
      },
    ];
    this.properties = [
      {
        displayName: 'Operation',
        name: 'operation',
        type: 'options',
        noDataExpression: true,
        options: [
          {
            name: 'Send Message',
            value: 'sendMessage',
          },
          {
            name: 'Get Chats',
            value: 'getChats',
          },
        ],
        default: 'sendMessage',
      },
      {
        displayName: 'Chat ID',
        name: 'chatId',
        type: 'string',
        required: true,
        displayOptions: {
          show: {
            operation: ['sendMessage'],
          },
        },
        default: '',
        description: 'ID чата для отправки сообщения',
      },
      {
        displayName: 'Message',
        name: 'message',
        type: 'string',
        required: true,
        displayOptions: {
          show: {
            operation: ['sendMessage'],
          },
        },
        default: '',
        description: 'Текст сообщения для отправки',
      },
    ];
  }

  async execute() {
    // Здесь будет реализация выполнения операций
    throw new NodeOperationError(
      this.getNode(),
      'Этот узел является заглушкой и не выполняет реальных операций',
    );
  }
}

module.exports = { nodeClass: TelegramClient };
