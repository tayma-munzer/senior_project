from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import *
from .serializers import *
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate

# Create your views here.

@api_view(['POST'])
def register(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        token, _ = Token.objects.get_or_create(user=user)
        role = request.data.get('role')
        if role =='actor':
            additional_info_data = request.data.get('additional_info', {})
            additional_info_serializer = AdditionalinfoSerializer(data=additional_info_data)
            if additional_info_serializer.is_valid():
                additional_info = additional_info_serializer.save(actor=user) 
                return Response({'token': token.key}, status=status.HTTP_201_CREATED)
            else :
                return Response(additional_info_serializer.errors,status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({'token': token.key}, status=status.HTTP_201_CREATED)
    else :
        return Response(serializer.errors,status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def login(request):
    email = request.data.get('email')
    password = request.data.get('password')
    user = authenticate(request, username=email, password=password)
    if user is not None:
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token': token.key}, status=status.HTTP_200_OK)
    else:
        return Response({'error': 'Invalid email or password','user':user,'email':email,'password':password}, status=status.HTTP_400_BAD_REQUEST)