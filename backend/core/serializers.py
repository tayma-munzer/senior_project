from rest_framework import serializers
from .models import *

class CountriesSerializer(serializers.ModelSerializer):
    class Meta:
        model = countries
        fields = ['id','contry']

class ActingTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActingType
        fields = ['id','type']

class RoleTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = RoleType
        fields = ['id','role_type']

class BuildingStyleSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuildingStyle
        fields = ['id','building_style']

class BuildingTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuildingType
        fields = ['id','building_type']

class AdditionalinfoSerializer(serializers.ModelSerializer):
    current_country = CountriesSerializer(read_only = True)
    current_country_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = actor_additional_info
        fields = ['current_country','current_country_id','available','approved','personal_image','date_of_birth']

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','first_name', 'last_name', 'email','password','role','phone_number','landline_number']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(**validated_data)
        user.set_password(validated_data['password'])  # Hash the password
        user.save()
        return user
        


class ArtworkSerializer(serializers.ModelSerializer):
    director = UserSerializer(read_only = True)
    director_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = artwork
        fields = ['id','title','poster','director','done','director_id']

class FilmingLocationSerializer(serializers.ModelSerializer):
    building_style = BuildingStyleSerializer(read_only=True)  
    building_style_id = serializers.IntegerField(write_only=True)
    building_type = BuildingTypeSerializer(read_only=True)
    building_type_id = serializers.IntegerField(write_only=True)
    building_owner = UserSerializer(read_only = True)
    building_owner_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = filming_location
        fields = ['id','location','detailed_address','desc','building_style','building_type','building_owner','building_owner_id','building_type_id','building_style_id']

class SceneSerializer(serializers.ModelSerializer):
    artwork_id = serializers.IntegerField(write_only=True)
    location_id = serializers.IntegerField(write_only=True,required=False)
    artwork = ArtworkSerializer(read_only=True)
    location = FilmingLocationSerializer(read_only=True)
    class Meta:
        model = scenes
        fields = ['id','title','start_date','end_date','scene_number','done','artwork','location','artwork_id','location_id']

class ArtworkActorsSerializer(serializers.ModelSerializer):
    approved = serializers.BooleanField(read_only=True)
    actor_id = serializers.IntegerField(write_only=True)
    role_type_id = serializers.IntegerField(write_only=True,required=False)
    actor = UserSerializer(read_only=True)
    role_type = RoleTypeSerializer(read_only=True)
    artwork=ArtworkSerializer(read_only=True)
    artwork_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = artwork_actors
        fields = ['id','actor', 'role_type', 'approved','actor_id','role_type_id','artwork','artwork_id']   


class SceneActorsSerializer(serializers.ModelSerializer):
    actor_id = serializers.IntegerField(write_only=True)
    actor = UserSerializer(read_only=True)
    scene=SceneSerializer(read_only=True)
    scene_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = scene_actors
        fields = ['id','actor','actor_id','scene','scene_id']   

class favoraitesSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField(write_only=True)
    user = UserSerializer(read_only=True)
    location=FilmingLocationSerializer(read_only=True)
    location_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = favoraites
        fields = ['id','user','user_id','location','location_id'] 


class artworkGallerySerializer(serializers.ModelSerializer):
    actor_id = serializers.IntegerField(write_only=True)
    actor = UserSerializer(read_only=True)
    role_type=RoleTypeSerializer(read_only=True)
    role_type_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = artwork_gallery
        fields = ['id','actor','artwork_name','poster','character_name','role_type','role_type_id','actor_id'] 

class actorActingTypeSerializer(serializers.ModelSerializer):
    acting_type_id = serializers.IntegerField(write_only=True)
    acting_type = ActingTypeSerializer(read_only=True)
    class Meta:
        model = actor_acting_types
        fields = ['id','actor','acting_type','acting_type_id'] 

class locationImageSerializer(serializers.ModelSerializer):
    location_id = serializers.IntegerField(write_only=True)
    location = FilmingLocationSerializer(read_only=True)
    class Meta:
        model = location_photos
        fields = ['id','location','location_id','photo'] 

class locationVideoSerializer(serializers.ModelSerializer):
    location_id = serializers.IntegerField(write_only=True)
    location = FilmingLocationSerializer(read_only=True)
    class Meta:
        model = location_videos
        fields = ['id','location','location_id','video'] 

class OfficialDocumentSerializer(serializers.ModelSerializer):
    actor = UserSerializer(read_only = True)
    actor_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = official_document
        fields = ['id','document','actor','actor_id']

class StoryBoardSerializer(serializers.ModelSerializer):
    director_id = serializers.IntegerField(write_only=True)
    director = UserSerializer(read_only=True)
    class Meta:
        model = story_board
        fields = ['id','director','director_id','image_base64','prompt'] 

class TrailerSerializer(serializers.ModelSerializer):
    # director_id = serializers.IntegerField(write_only=True)
    # director = UserSerializer(read_only=True)
    # ,'director_id'
    class Meta:
        model = trailer
        fields = ['id','director','video_url','trailer','video_duration','num_scenes','text_idea'] 

class SyncLipsSerializer(serializers.ModelSerializer):
    class Meta:
        model = sync_lips
        fields = ['id','director','video','text','generated_video'] 

class BookingDatesSerializer(serializers.ModelSerializer):
    location_id = serializers.IntegerField(write_only=True)
    location = FilmingLocationSerializer(read_only=True)
    class Meta:
        model = booking_dates
        fields = ['id','location','location_id','date'] 

class CameraLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = camera_location
        fields = ['id','director','video','generated_video'] 
