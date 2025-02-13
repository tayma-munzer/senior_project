from django.shortcuts import render, redirect, get_object_or_404
from rest_framework.decorators import api_view ,permission_classes
from rest_framework.response import Response
from rest_framework import status
from .models import *
from .serializers import *
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
import json
from django.db.models import Q
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
import requests
from django.core.files.base import ContentFile
import base64
import uuid

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
        return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated,])
def artwork_list(request):
    if request.method == 'GET':
        user = request.user
        artworks = artwork.objects.filter(director=user).order_by('done')
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
        buildingStyle = request.query_params.get('building_style')
        buildingType = request.query_params.get('building_type')
        dates = request.query_params.getlist('date')
        search = request.query_params.get('search')
        if buildingStyle :
            locations = locations.filter(building_style__building_style = buildingStyle)
        if buildingType :
            locations = locations.filter(building_type__building_type = buildingType)
        if search :
            locations = locations.filter(desc__contains = search)
        if dates:
            locations = locations.exclude(booking_dates__date__in=dates).distinct()
        locations_data = []
        for location in locations:
            serializer = FilmingLocationSerializer(location)
            location_photo = location_photos.objects.filter(location=location).first()
            if location_photo :
                photo_url = location_photo.photo.url  
            else:
                photo_url = '/media/images/default_location.jpg'
            location_data = serializer.data
            location_data['photo'] = photo_url
            locations_data.append(location_data)
        return Response(locations_data,status=status.HTTP_200_OK)

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
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = FilmingLocationSerializer(location)
        location_photo = location_photos.objects.filter(location = location).first()
        if location_photo:
            photo_url = location_photo.photo.url
        else:
            photo_url = '/media/images/default_location.jpg'  
        response_data = serializer.data
        response_data['photo'] = photo_url
        return Response(response_data)

    elif request.method == 'PUT':
        data=request.data
        data['building_owner_id']=request.user.id
        serializer = FilmingLocationSerializer(location, data=data)
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
    locations_data = []
    for location in filming_locations:
        serializer = FilmingLocationSerializer(location)
        location_photo = location_photos.objects.filter(location=location).first()
        if location_photo :
            photo_url = location_photo.photo.url  
        else:
            photo_url = '/media/images/default_location.jpg'
        location_data = serializer.data
        location_data['photo'] = photo_url
        locations_data.append(location_data)
    return Response(locations_data,status=status.HTTP_200_OK)

@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def artwork_done(request,pk):
    try:
        artwork_instance = artwork.objects.get(id=pk)
        artwork_instance.done = True
        artwork_instance.save()
        return Response({'message': 'artwork updated successfully.'}, status=status.HTTP_200_OK)
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
    

@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def scene_location(request,pk):
    try:
        scene_instance = scenes.objects.get(id=pk)
        try:
            data = json.loads(request.body)
            location_id = data.get("location_id")
            location_instance = filming_location.objects.get(pk=location_id)
            scene_instance.location_id = location_instance.id
            scene_instance.save()
            return Response({'message': 'scene updated successfully.'}, status=status.HTTP_200_OK)
        except filming_location.DoesNotExist:
            return Response({'error': 'location not found.'}, status=status.HTTP_404_NOT_FOUND)
    except artwork.DoesNotExist:
        return Response({'error': 'scene not found.'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['POST','GET'])
@permission_classes([IsAuthenticated])
def artworkactors(request, pk):
    if request.method == 'POST':
        try:
            artwork_instance = artwork.objects.get(id=pk)
            actors = request.data.get('actors', [])
            for actor in actors:
                actor['artwork_id'] = artwork_instance.id
                serializer = ArtworkActorsSerializer(data=actor)
                if serializer.is_valid():
                    serializer.save()
                    channel_layer = get_channel_layer()
                    actor_id = actor['actor_id']
                    async_to_sync(channel_layer.group_send)(
                        f'notifications_{actor_id}',
                        {
                            'type': 'send_notification',
                            'notification': serializer.data,
                            'title':'acting_request'
                        }
                    )
                else:
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
            return Response({'message': 'actors added successfully.'}, status=status.HTTP_201_CREATED)
        except artwork.DoesNotExist:
            return Response({'error': 'artwork not found.'}, status=status.HTTP_404_NOT_FOUND)
    elif request.method == 'GET':
        try:
            artwork_instance = artwork.objects.get(id=pk)
            actors = artwork_actors.objects.filter(artwork=artwork_instance)
            serializer = ArtworkActorsSerializer(actors,many=True)
            response_data = serializer.data
            for data in response_data:
                actor = data['actor']
                info = actor_additional_info.objects.get(actor_id=data['actor']['id'])
                infoSerializer = AdditionalinfoSerializer(info)
                data['actor']['additional_info']=infoSerializer.data
            return Response(response_data)
        except artwork.DoesNotExist:
            return Response({'error': 'artwork not found.'}, status=status.HTTP_404_NOT_FOUND)
        
@api_view(['POST','GET'])
@permission_classes([IsAuthenticated])
def sceneactors(request, pk):
    if request.method == 'POST':
        try:
            scene_instance = scenes.objects.get(id=pk)
            actors = request.data.get('actors', [])
            for actor in actors:
                actor['scene_id'] = scene_instance.id
                serializer = SceneActorsSerializer(data=actor)
                if serializer.is_valid():
                    serializer.save()
                    channel_layer = get_channel_layer()
                    scene_number = scene_instance.scene_number
                    start_date = scene_instance.start_date
                    end_date = scene_instance.end_date
                    artwork_name = scene_instance.artwork.title
                    actor_id = actor['actor_id']
                    notification_message = '{artwork_name} في العمل {scene_number} للمشهد رقم {end_date} إلى {start_date} هل يناسبك التصوير من'.format(
                        artwork_name=artwork_name,
                        scene_number=scene_number,
                        end_date=end_date,
                        start_date=start_date
                    )
                    async_to_sync(channel_layer.group_send)(
                        f'notifications_{actor_id}',
                        {
                            'type': 'send_notification',
                            'notification':notification_message,
                            'title':'scene_filming_time_request'
                        }
                    )
                else:
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
            return Response({'message': 'actors added successfully to scene.'}, status=status.HTTP_201_CREATED)
        except scenes.DoesNotExist:
            return Response({'error': 'scene not found.'}, status=status.HTTP_404_NOT_FOUND)
    elif request.method == 'GET':
        try:
            scene_instance = scenes.objects.get(id=pk)
            actors = scene_actors.objects.filter(scene=scene_instance)
            serializer = SceneActorsSerializer(actors,many=True)
            response_data = serializer.data
            for data in response_data:
                actor = data['actor']
                info = actor_additional_info.objects.get(actor_id=data['actor']['id'])
                infoSerializer = AdditionalinfoSerializer(info)
                data['actor']['additional_info']=infoSerializer.data
            return Response(response_data)
        except scenes.DoesNotExist:
            return Response({'error': 'scene not found.'}, status=status.HTTP_404_NOT_FOUND)
        
@api_view(['GET'])
@permission_classes([IsAuthenticated,])
def owner_favoraites(request):
    user = request.user
    user_favoraites = favoraites.objects.filter(user=user)
    serializer = favoraitesSerializer(user_favoraites, many=True) 
    return Response(serializer.data,status=status.HTTP_200_OK)

@api_view(['POST','DELETE'])
@permission_classes([IsAuthenticated,])
def favoraite_location(request,pk):
    if request.method == 'POST':
        try:
            location = filming_location.objects.get(pk=pk)
        except filming_location.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        user = request.user
        fav={}
        fav['user_id']=user.id
        fav['location_id']=pk
        serializer = favoraitesSerializer(data=fav)
        if serializer.is_valid():
            serializer.save()
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
        return Response(serializer.data,status=status.HTTP_200_OK)
    elif request.method == 'DELETE':
        user = request.user
        try:
            location = favoraites.objects.get(location_id=pk,user=user)
            location.delete()
            return Response({'message': 'location deleted from favorates.'}, status=status.HTTP_200_OK)
        except favoraites.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        
@api_view(['PUT','GET'])
@permission_classes([IsAuthenticated,])
def user_profile(request):
    user=request.user
    if request.method == 'GET':
        serializer = UserSerializer(user)
        response_data = serializer.data
        if user.role == "actor":
            info = actor_additional_info.objects.get(actor=user)
            infoSerializer = AdditionalinfoSerializer(info)
            response_data['additional_info']=infoSerializer.data
        return Response(response_data)

    elif request.method == 'PUT':
        print(user.role)
        serializer = UserSerializer(user, data=request.data,partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def additional_info(request):
    user=request.user
    try:
        info = actor_additional_info.objects.get(actor=user)
    except actor_additional_info.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if 'approved' in request.data:
        del request.data['approved']
    serializer = AdditionalinfoSerializer(info, data=request.data,partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET','POST'])
@permission_classes([IsAuthenticated,])
def artworkGallary(request):
    user=request.user
    if request.method == 'POST':
        data = request.data
        data['actor_id'] = user.id
        serializer = artworkGallerySerializer(data=data)
        if serializer.is_valid():
            serializer.save() 
            return Response(serializer.data, status=status.HTTP_201_CREATED) 
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  
    elif request.method == 'GET':
        try:
            gallary = artwork_gallery.objects.filter(actor = user)
            serializer = artworkGallerySerializer(gallary, many=True) 
            return Response(serializer.data,status=status.HTTP_200_OK)
        except artwork_gallery.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
    
@api_view(['GET','PUT','DELETE'])
@permission_classes([IsAuthenticated,])
def artwork_from_artworkGallary(request,pk):   
    user = request.user 
    try:
        artwork = artwork_gallery.objects.get(pk=pk)
    except artwork_gallery.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = artworkGallerySerializer(artwork)
        return Response(serializer.data)

    elif request.method == 'PUT':
        data = request.data 
        data['actor_id']=user.id
        serializer = artworkGallerySerializer(artwork, data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        artwork.delete()
        return Response(status=status.HTTP_200_OK)

@api_view(['GET','POST'])
@permission_classes([IsAuthenticated,])
def actorActingTypes(request):
    user=request.user
    if request.method == 'POST':
        data = request.data
        data['actor_id'] = user.id
        serializer = actorActingTypeSerializer(data=data)
        if serializer.is_valid():
            serializer.save() 
            return Response(serializer.data, status=status.HTTP_201_CREATED) 
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  
    elif request.method == 'GET':
        try:
            actingTypes = actor_acting_types.objects.filter(actor = user)
            serializer = actorActingTypeSerializer(actingTypes, many=True) 
            return Response(serializer.data,status=status.HTTP_200_OK)
        except actor_acting_types.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
    
@api_view(['DELETE'])
@permission_classes([IsAuthenticated,])
def deleteActorActingType(request,pk):
    try:
        actingType = actor_acting_types.objects.get(pk=pk)
    except actor_acting_types.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    actingType.delete()
    return Response(status=status.HTTP_200_OK)  

@api_view(['GET'])
def acting_type_list(request):
    acting_types = ActingType.objects.all()
    serializer = ActingTypeSerializer(acting_types, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def countries_list(request):
    country_list = countries.objects.all()
    serializer = CountriesSerializer(country_list, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def role_type_list(request):
    role_types = RoleType.objects.all()
    serializer = RoleTypeSerializer(role_types, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def building_style_list(request):
    building_styles = BuildingStyle.objects.all()
    serializer = BuildingStyleSerializer(building_styles, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def building_type_list(request):
    building_types = BuildingType.objects.all()
    serializer = BuildingTypeSerializer(building_types, many=True)
    return Response(serializer.data)

from datetime import date, timedelta
from django.utils import timezone

@api_view(['GET'])
def actors_list(request):
    actor_ids = actor_additional_info.objects.filter(approved=True).values_list('actor_id', flat=True).distinct()
    actors = User.objects.filter(id__in=actor_ids,role="actor").order_by('-additional_info__available')
    acting_type = request.query_params.get('acting_type')
    living_country = request.query_params.get('country')
    available = request.query_params.get('available')
    min_age = request.query_params.get('min_age')
    max_age = request.query_params.get('max_age')
    ordering = request.query_params.get('ordering')
    search = request.query_params.get('search')
    if acting_type:
        actor_ids = actor_acting_types.objects.filter(acting_type__type=acting_type).values_list('actor_id', flat=True).distinct()
        actors = actors.filter(id__in=actor_ids)
    if living_country :
        actor_ids = actor_additional_info.objects.filter(current_country__contry=living_country).values_list('actor_id', flat=True).distinct()
        actors = actors.filter(id__in=actor_ids)
    if available:
        actor_ids = actor_additional_info.objects.filter(available=available).values_list('actor_id', flat=True).distinct()
        actors = actors.filter(id__in=actor_ids)
    if search :
        search_terms = search.split()
        query = Q()
        for term in search_terms:
            query |= Q(first_name__icontains=term) | Q(last_name__icontains=term)
        actors = actors.filter(query)

    today = date.today()
    if min_age :
        min_birthdate = today - timedelta(days=int(min_age) * 365.25)
        actors = actors.filter(additional_info__date_of_birth__lte=min_birthdate)
    if max_age :
        max_birthdate = today - timedelta(days=int(max_age) * 365.25)
        actors = actors.filter(additional_info__date_of_birth__gte=max_birthdate)

    if ordering :
        if ordering == "age":
            actors = actors.order_by("additional_info__date_of_birth")
        if ordering == "-age":
            actors = actors.order_by("-additional_info__date_of_birth")
    serializer = UserSerializer(actors, many=True)
    response_data = serializer.data
    for data in response_data:
        info = actor_additional_info.objects.get(actor_id=data['id'])
        infoSerializer = AdditionalinfoSerializer(info)
        data['additional_info']=infoSerializer.data
    return Response(response_data)

@api_view(['GET','DELETE'])
@permission_classes([IsAuthenticated,])
def location_image_detail(request, pk):
    try:
        image = location_photos.objects.get(pk=pk)
    except location_photos.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = locationImageSerializer(image)
        return Response(serializer.data)

    elif request.method == 'DELETE':
        image.delete()
        return Response(status=status.HTTP_200_OK)
    
@api_view(['GET','POST'])
@permission_classes([IsAuthenticated,])
def location_image_list(request, pk):
    try:
        location = filming_location.objects.get(pk=pk)
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'GET':
        images = location_photos.objects.filter(location=location)
        serializer = locationImageSerializer(images, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        images = request.data.get('photos', [])
        print("the array is readed")
        for image in images:
            print("image is entered")
            image['location_id'] = location.id
            print(image['location_id'])
            print(image['photo'])
            serializer = locationImageSerializer(data=image)
            if serializer.is_valid():
                serializer.save()
                print("image is saved successfully")
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
        return Response({'message': 'photos added successfully.'}, status=status.HTTP_201_CREATED)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def test_add_location_image(request, pk):
    try:
        location = filming_location.objects.get(pk=pk)
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND) 
    
    data = request.data
    data['location_id']=location.id
    serializer = locationImageSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED) 
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
    

@api_view(['GET','DELETE'])
@permission_classes([IsAuthenticated,])
def location_video_detail(request, pk):
    try:
        video = location_videos.objects.get(pk=pk)
    except location_videos.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = locationVideoSerializer(video)
        return Response(serializer.data)

    elif request.method == 'DELETE':
        video.delete()
        return Response(status=status.HTTP_200_OK)
    
@api_view(['GET','POST'])
@permission_classes([IsAuthenticated,])
def location_video_list(request, pk):
    try:
        location = filming_location.objects.get(pk=pk)
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'GET':
        videos = location_videos.objects.filter(location=location)
        serializer = locationVideoSerializer(videos, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        videos = request.data.get('videos', [])
        for video in videos:
            video['location_id'] = location.id
            serializer = locationVideoSerializer(data=video)
            if serializer.is_valid():
                serializer.save()
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
        return Response({'message': 'videos added successfully.'}, status=status.HTTP_201_CREATED)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def test_add_location_video(request, pk):
    try:
        location = filming_location.objects.get(pk=pk)
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND) 
    
    data = request.data
    data['location_id']=location.id
    serializer = locationVideoSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED) 
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
    
@api_view(['PATCH','DELETE'])
@permission_classes([IsAuthenticated,])
def actor_image(request):
    user=request.user
    additional_info = actor_additional_info.objects.get(actor=user)
    if request.method == 'PATCH':
        if 'approved' in request.data:
            del request.data['approved']
        serializer = AdditionalinfoSerializer(additional_info, data=request.data,partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == 'DELETE':
        default_image_path = 'personal_image/default.jpg'
        additional_info.personal_image = default_image_path
        additional_info.save()
        serializer = AdditionalinfoSerializer(additional_info)
        return Response(serializer.data, status=status.HTTP_200_OK)
    

def pending_actors(request):
    actors = User.objects.filter(additional_info__approved=False)
    return render(request, 'pending_actors.html', {'actors': actors})

def approve_actor(request, actor_id):
    actor = get_object_or_404(User, id=actor_id)
    actor.additional_info.update(approved=True)
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f'notifications_{actor_id}',
        {
            'type': 'send_notification',
            'notification': 'مرحبا بك في تطبيقنا ,تم الموافقة على انشاء حسابك',
            'title':'public_notifcation'
        }
    )
    return redirect('pending_actors')

def reject_actor(request, actor_id):
    actor = get_object_or_404(User, id=actor_id)
    actor.additional_info.update(approved=False)
    return redirect('pending_actors')

@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def add_official_doc(request):    
    data = request.data
    data['actor_id']=request.user.id
    serializer = OfficialDocumentSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED) 
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
    
@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def acting_request_approve(request,pk):
    try:
        artwork_actor = artwork_actors.objects.get(id=pk)
        artwork_actor.approved = True
        artwork_actor.save()
        channel_layer = get_channel_layer()
        actor_name = artwork_actor.actor.first_name +" "+ artwork_actor.actor.last_name
        artwork_title = artwork_actor.artwork.title
        async_to_sync(channel_layer.group_send)(
            f'notifications_{artwork_actor.artwork.director.id}',
            {
                'type': 'send_notification',
                'notification':f'{artwork_title} على طلب الانضمام للعمل الفني {actor_name} وافق الممثل',
                'title':'public_notifcation'
            }
        )
        return Response({'message': 'status updated successfully.'}, status=status.HTTP_200_OK)
    except artwork.DoesNotExist:
        return Response({'error': 'artwork actor not found.'}, status=status.HTTP_404_NOT_FOUND)
    

@api_view(['PATCH'])
@permission_classes([IsAuthenticated,])
def acting_request_reject(request,pk):
    try:
        artwork_actor = artwork_actors.objects.get(id=pk)
        artwork_actor.delete()
        channel_layer = get_channel_layer()
        actor_name = artwork_actor.actor.first_name +" "+ artwork_actor.actor.last_name
        artwork_title = artwork_actor.artwork.title
        async_to_sync(channel_layer.group_send)(
            f'notifications_{artwork_actor.artwork.director.id}',
            {
                'type': 'send_notification',
                'notification':f'{artwork_title} طلب الانضمام للعمل الفني {actor_name} رفض الممثل',
                'title':'public_notifcation'
            }
        )
        return Response({'message': 'status updated successfully.'}, status=status.HTTP_200_OK)
    except artwork.DoesNotExist:
        return Response({'error': 'artwork actor not found.'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def story_board(request):    
    prompt = request.data.get('prompt')
    if not prompt:
        return Response({"error": "Prompt is required."}, status=status.HTTP_400_BAD_REQUEST)
    endpoint = 'https://aeaf-34-87-122-38.ngrok-free.app/generate'
    response = requests.post(endpoint, json={'prompt': prompt})
    if response.status_code == 200:
        response_data = response.json()
        text = response_data.get('prompt')
        image_base64 = response_data.get('image_base64')
        image_data = base64.b64decode(image_base64)
        image_name = f"{uuid.uuid4()}.jpg"
        image_file = ContentFile(image_data, name=image_name)
        data={}
        data['image_base64'] = image_file
        data['director_id'] = request.user.id
        data['prompt']=prompt
        image_serializer = StoryBoardSerializer(data=data)
        if image_serializer.is_valid():
            image_model_instance = image_serializer.save()  # Save the image instance
            return Response({"message": "Image saved successfully.", "id": image_model_instance.id}, status=status.HTTP_201_CREATED)
        return Response(image_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
from django.core.files.base import ContentFile
import os
import json
@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def gettrailer(request):    
    video_url = request.data.get('video_url')
    video_duration = request.data.get('video_duration')
    num_scenes = request.data.get('num_scenes')
    text_idea = request.data.get('text_idea')
    endpoint = 'https://b059-35-188-156-101.ngrok-free.app/generate_trailer/'
    response = requests.post(endpoint, json={'text_idea': text_idea,'video_url':video_url,'video_duration':video_duration,'num_scenes':num_scenes})
    if response.status_code == 200:
        video_content = response.content
        video = trailer()
        video.video_url=video_url
        video.video_duration=video_duration
        video.num_scenes=num_scenes
        video.text_idea=text_idea
        video.director=request.user
        filename = 'video_{}.mp4'.format(os.path.basename(endpoint))
        video.trailer.save(filename, ContentFile(video_content), save=True)
        serializer = TrailerSerializer(video)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def synclips(request):    
    inputvideo = request.FILES.get('video')
    text = request.data.get('text')
    endpoint = 'https://9e01-34-106-86-187.ngrok-free.app/sync-lips/'
    files = {'video': inputvideo}
    data = {'text': text}
    response = requests.post(endpoint, files=files,data=data)
    if response.status_code == 200:
        video_content = response.content
        video = sync_lips()
        video.text=text
        video.director=request.user
        video.video = inputvideo
        outputfilename = 'video_{}.mp4'.format(os.path.basename(endpoint))
        video.generated_video.save(outputfilename, ContentFile(video_content), save=True)
        serializer = SyncLipsSerializer(video)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

@api_view(['POST','GET','DELETE'])
@permission_classes([IsAuthenticated,])
def booking_location(request,id):
    try:
        location = filming_location.objects.get(id=id)
    except filming_location.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'GET':
        bookingDates = booking_dates.objects.filter(location=location)
        dates = [booking.date for booking in bookingDates]
        serializer = FilmingLocationSerializer(location)
        return Response({"dates": dates,"location":serializer.data}, status=status.HTTP_200_OK)
    elif request.method == 'POST':   
        dates = request.data.get('dates')
        for date in dates:
            serializer = BookingDatesSerializer(data= {'location_id':location.id,'date':date})
            if serializer.is_valid():
                serializer.save()
            else:
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 
        return Response(status=status.HTTP_200_OK)
    elif request.method == 'DELETE':
        dates = request.data.get('dates')
        for date in dates :
            booking_dates.objects.get(location=location,date=date).delete()
        return Response(status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([IsAuthenticated,])
def cameraLocation(request):    
    inputvideo = request.FILES.get('file')
    endpoint = 'https://0aa9-34-126-148-53.ngrok-free.app/process-video/'
    files = {'file': inputvideo}
    response = requests.post(endpoint, files=files)
    if response.status_code == 200:
        # video_content = response.content
        video = camera_location()
        video.director=request.user
        video.video = inputvideo
        outputfilename = 'video_{}.mp4'.format(os.path.basename(endpoint))
        video.generated_video.save(outputfilename, ContentFile(response.content), save=True)
        serializer = CameraLocationSerializer(video)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

## to make notifications in views 
    # channel_layer = get_channel_layer()
    # async_to_sync(channel_layer.group_send)(
    #     f'notifications_{user.id}',
    #     {
    #         'type': 'send_notification',
    #         'notification': serializer.data
    #     }
    # )