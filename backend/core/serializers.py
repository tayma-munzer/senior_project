from rest_framework import serializers
from .models import *

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','first_name', 'last_name', 'email','password','role','phone_number','landline_number']
    
    def create(self, validated_data):
        user = User(**validated_data)
        user.set_password(validated_data['password'])  # Hash the password
        user.save()
        return user
        

class AdditionalinfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = actor_additional_info
        fields = ['current_country','available','approved']

