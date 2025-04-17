import {
  ICredentialType,
  INodeProperties,
} from 'n8n-workflow';

export class TelegramUserApi implements ICredentialType {
  name = 'telegramUserApi';
  displayName = 'Telegram User API';
  documentationUrl = 'https://github.com/CreatmanCEO/telegram-user-api';
  properties: INodeProperties[] = [
    {
      displayName: 'API ID / API ID (Telegram)',
      name: 'apiId',
      type: 'string',
      default: '',
      required: true,
    },
    {
      displayName: 'API Hash / API Hash (Telegram)',
      name: 'apiHash',
      type: 'string',
      typeOptions: { password: true },
      default: '',
      required: true,
    },
    {
      displayName: 'API Base URL / URL API',
      name: 'apiBaseUrl',
      type: 'string',
      default: 'http://localhost:9503/api',
      required: true,
    },
  ];
}
