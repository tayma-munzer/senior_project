from django.shortcuts import render
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
        search = request.query_params.get('search')
        if buildingStyle :
            locations = locations.filter(building_style__building_style = buildingStyle)
        if buildingType :
            locations = locations.filter(building_type__building_type = buildingType)
        if search :
            locations = locations.filter(desc__contains = search)
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
        print("the array in readed")
        for image in images:
            print("image in entered")
            image['location_id'] = location.id
            serializer = locationImageSerializer(data=image)
            if serializer.is_valid():
                serializer.save()
                print("image is saves successfully")
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
    



    ## to make notifications in views 
    # channel_layer = get_channel_layer()
    # async_to_sync(channel_layer.group_send)(
    #     f'notifications_{user.id}',
    #     {
    #         'type': 'send_notification',
    #         'notification': serializer.data
    #     }
    # )