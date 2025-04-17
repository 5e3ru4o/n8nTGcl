import {
  INodeType,
  INodeTypeDescription,
  IExecuteFunctions,
} from 'n8n-workflow';

export class TelegramUser implements INodeType {
  description: INodeTypeDescription = {
    displayName: 'Telegram User / Пользователь Telegram',
    name: 'telegramUser',
    group: ['communication'],
    version: 1,
    description: 'Send personal messages via Telegram User API / Отправка личных сообщений через Telegram User API',
    defaults: {
      name: 'Telegram User',
      color: '#0088cc',
    },
    inputs: ['main'],
    outputs: ['main'],
    credentials: [
      {
        name: 'telegramUserApi',
        required: true,
        testedBy: 'testAuth',
      },
    ],
    properties: [
      {
        displayName: 'Command / Команда',
        name: 'command',
        type: 'options',
        options: [
          { name: 'Send Message / Отправить сообщение', value: 'send_message' },
          { name: 'Get Contacts / Получить контакты', value: 'get_contacts' },
        ],
        default: 'send_message',
        required: true,
      },
      {
        displayName: 'User / Пользователь',
        name: 'user',
        type: 'string',
        displayOptions: {
          show: { command: ['send_message'] },
        },
        required: false,
      },
      {
        displayName: 'Message / Сообщение',
        name: 'message',
        type: 'string',
        displayOptions: {
          show: { command: ['send_message'] },
        },
        required: false,
      },
    ],
  };

  async execute(this: IExecuteFunctions) {
    const items = this.getInputData();
    const returnData = [];

    const credentials = await this.getCredentials('telegramUserApi');
    const apiBaseUrl = credentials.apiBaseUrl as string;
    const apiId = credentials.apiId as string;
    const apiHash = credentials.apiHash as string;

    for (let i = 0; i < items.length; i++) {
      const command = this.getNodeParameter('command', i) as string;
      const user = this.getNodeParameter('user', i, '') as string;
      const message = this.getNodeParameter('message', i, '') as string;

      let responseData;
      if (command === 'send_message') {
        if (!user || !message) {
          responseData = { error: true, message: 'User и Message обязательны / User and Message are required' };
        } else {
          responseData = await this.helpers.request({
            method: 'POST',
            url: `${apiBaseUrl}/send_message`,
            body: { peer: user, message, api_id: apiId, api_hash: apiHash },
            json: true,
          });
        }
      } else if (command === 'get_contacts') {
        responseData = await this.helpers.request({
          method: 'GET',
          url: `${apiBaseUrl}/contacts?api_id=${apiId}&api_hash=${apiHash}`,
          json: true,
        });
      } else {
        responseData = { error: true, message: 'Неизвестная команда / Unknown command' };
      }
      returnData.push({ json: responseData });
    }

    return this.prepareOutputData(returnData);
  }
}
