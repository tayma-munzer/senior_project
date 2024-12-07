from rest_framework import serializers
from .models import *

class CountriesSerializer(serializers.Serializer):
    class Meta:
        model = countries
        fields = ['id','country']

class ActingTypeSerializer(serializers.Serializer):
    class Meta:
        model = ActingType
        fields = ['id','type']

class RoleTypeSerializer(serializers.Serializer):
    class Meta:
        model = RoleType
        fields = ['id','role_type']

class BuildingStyleSerializer(serializers.Serializer):
    class Meta:
        model = BuildingStyle
        fields = ['id','building_style']

class BuildingTypeSerializer(serializers.Serializer):
    class Meta:
        model = BuildingType
        fields = ['id','building_type']
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
        

class AdditionalinfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = actor_additional_info
        fields = ['current_country','available','approved']

class ArtworkSerializer(serializers.ModelSerializer):
    director = UserSerializer(read_only = True)
    director_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = artwork
        fields = ['id','title','poster','director','done','director_id']

class FilmingLocationSerializer(serializers.ModelSerializer):
    building_style = serializers.SerializerMethodField()  
    building_style_id = serializers.IntegerField(write_only=True)
    building_type = serializers.SerializerMethodField()  
    building_type_id = serializers.IntegerField(write_only=True)
    building_owner = UserSerializer(read_only = True)
    building_owner_id = serializers.IntegerField(write_only=True)
    class Meta:
        model = filming_location
        fields = ['id','location','detailed_address','desc','building_style','building_type','building_owner','building_owner_id','building_type_id','building_style_id']

    def get_building_style(self,obj):
        return obj.building_style.building_style 
    
    def get_building_type(self,obj):
        return obj.building_type.building_type
    
class SceneSerializer(serializers.ModelSerializer):
    artwork_id = serializers.IntegerField(write_only=True)
    location_id = serializers.IntegerField(write_only=True,required=False)
    artwork = ArtworkSerializer(read_only=True)
    location = FilmingLocationSerializer(read_only=True)
    class Meta:
        model = scenes
        fields = ['id','title','start_date','end_date','scene_number','done','artwork','location','artwork_id','location_id']

    

