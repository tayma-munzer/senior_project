from django.shortcuts import render
from rest_framework.decorators import api_view ,permission_classes
from rest_framework.response import Response
from rest_framework import status
from .models import *
from .serializers import *
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated

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
    
@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated,])
def artwork_list(request):
    if request.method == 'GET':
        artworks = artwork.objects.all()
        serializer = ArtworkSerializer(artworks, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = request.data
        data['director_id']= request.user.id
        serializer = ArtworkSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated,])
def artwork_detail(request, pk):
    try:
        artwork_detail = artwork.objects.get(pk=pk)
    except artwork.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ArtworkSerializer(artwork_detail)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = ArtworkSerializer(artwork_detail, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        artwork_detail.delete()
        return Response(status=status.HTTP_200_OK)
    
@api_view(['GET'])
@permission_classes([IsAuthenticated,])
def artwork_scenes(request, pk):
    try:
        artwork_instance = artwork.objects.get(id=pk)
        artwork_scenes = scenes.objects.filter(artwork=artwork_instance).order_by('-scene_number')
        serializer = SceneSerializer(artwork_scenes, many=True)
        return Response(serializer.data)
    except artwork_instance.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def add_scene(request):

    data = request.data 
    try:
        artwork_instance = artwork.objects.get(id=data['artwork_id'])
        last_scene = scenes.objects.filter(artwork=artwork_instance).order_by('-scene_number').first()
        if last_scene:
            new_scene_number = last_scene.scene_number + 1
        else:
            new_scene_number = 1
        data['scene_number'] = new_scene_number
        serializer = SceneSerializer(data=data)
        if serializer.is_valid():
            serializer.save() 
            return Response(serializer.data, status=status.HTTP_201_CREATED) 
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  
    except artwork.DoesNotExist:
        return Response({'error': 'Artwork not found.'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated,])
def scene_detail(request, pk):
    try:
        scene_detail = scenes.objects.get(pk=pk)
    except scene_detail.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = SceneSerializer(scene_detail)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = SceneSerializer(scene_detail, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        scene_detail.delete()
        return Response(status=status.HTTP_200_OK)
    

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated,])
def filming_location_list(request):
    if request.method == 'GET':
        locations = filming_location.objects.all()
        serializer = FilmingLocationSerializer(locations, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = request.data
        data['building_owner_id']=request.user.id
        serializer = FilmingLocationSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated,])
def filming_location_detail(request, pk):
    try:
        location = filming_location.objects.get(pk=pk)
    except artwork.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = FilmingLocationSerializer(location)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = FilmingLocationSerializer(location, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        location.delete()
        return Response(status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated,])
def owner_filming_locations(request):
    user = request.user
    filming_locations = filming_location.objects.filter(building_owner=user)
    serializer = FilmingLocationSerializer(filming_locations, many=True) 
    return Response(serializer.data,status=status.HTTP_200_OK)

@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def artwork_done(request,pk):
    try:
        artwork_instance = artwork.objects.get(id=pk)
        artwork_instance.done = True
        artwork_instance.save()
        return Response({'message': 'scene updated successfully.'}, status=status.HTTP_200_OK)
    except artwork.DoesNotExist:
        return Response({'error': 'scene not found.'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def scene_done(request,pk):
    try:
        scene_instance = scenes.objects.get(id=pk)
        scene_instance.done = True
        scene_instance.save()
        return Response({'message': 'scene updated successfully.'}, status=status.HTTP_200_OK)
    except artwork.DoesNotExist:
        return Response({'error': 'scene not found.'}, status=status.HTTP_404_NOT_FOUND)