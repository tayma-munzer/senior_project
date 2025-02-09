# consumers.py

import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import sync_to_async

import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "backend.settings")

import django
django.setup()

from rest_framework.authtoken.models import Token

class NotificationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        token = self.scope['query_string'].decode().split('=')[-1] if b'token=' in self.scope['query_string'] else None
        if token:
            try:
                token_instance = await sync_to_async(Token.objects.get)(key=token)
                self.user = await sync_to_async(lambda: token_instance.user)()
            except Token.DoesNotExist:
                self.close()
        else :
            self.close()
        self.room_group_name = f'notifications_{self.user.id}'
        print(f'notifications_{self.user.id}')


        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.room_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        
        pass

    async def send_notification(self, event):
        await self.send(text_data=json.dumps({
            'notification': event['notification'],
            'title':event['title']
        }))