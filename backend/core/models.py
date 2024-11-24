from django.db import models

# Create your models here.

class countries(models.Model):
    contry = models.CharField(max_length=255)

class acting_type(models.Model):
    type = models.CharField(max_length=255)

class user(models.Model):
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField()
    password = models.CharField(max_length=255)
    role = models.CharField(max_length=255)
    phone_number = models.IntegerField()
    landline_number = models.IntegerField()

class role_type(models.Model):
    role_type = models.CharField(max_length=255)

class building_style(models.Model):
    building_style = models.CharField(max_length=255)

class building_type(models.Model):
    building_type = models.CharField(max_length=255)

class actor(models.Model):
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    email = models.EmailField()
    password = models.CharField(max_length=255)
    phone_number = models.IntegerField()
    landline_number = models.IntegerField()
    current_country = models.ForeignKey(countries,on_delete=models.CASCADE)
    available = models.BooleanField()
    approved = models.BooleanField()

class official_document(models.Model):
    document = models.CharField(max_length=255)
    actor = models.ForeignKey(actor,on_delete=models.CASCADE)

class actor_acting_types(models.Model):
    actor = models.ForeignKey(actor,on_delete=models.CASCADE)
    acting_type= models.ForeignKey(acting_type,on_delete=models.CASCADE)

class artwork_gallery(models.Model):
    actor = models.ForeignKey(actor,on_delete=models.CASCADE)
    artwork_name = models.CharField(max_length=255)
    poster = models.CharField(max_length=255)
    character_name = models.CharField(max_length=255)
    role_type = models.ForeignKey(role_type,on_delete=models.CASCADE)

class artwork(models.Model):
    title = models.CharField(max_length=255)
    poster = models.CharField(max_length=255)
    director = models.ForeignKey(user,on_delete=models.CASCADE)
    done = models.BooleanField()

class artwork_actors(models.Model):
    actor = models.ForeignKey(actor,on_delete=models.CASCADE)
    artwork = models.ForeignKey(artwork,on_delete=models.CASCADE)
    role_type = models.ForeignKey(role_type,on_delete=models.CASCADE)
    approved = models.BooleanField()

class filming_location(models.Model):
    location = models.CharField(max_length=255)
    detailed_address = models.CharField(max_length=255)
    desc = models.CharField(max_length=255)
    building_style = models.ForeignKey(building_style,on_delete=models.CASCADE)
    building_type = models.ForeignKey(building_type,on_delete=models.CASCADE)
    building_owner = models.ForeignKey(user,on_delete=models.CASCADE)
    
class booking_dates(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    start_date = models.DateField()
    end_date = models.DateField()

class location_photos(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    photo = models.CharField(max_length=255)

class location_videos(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    video = models.CharField(max_length=255)

class favoraites(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    user = models.ForeignKey(user,on_delete=models.CASCADE)
    
class scenes(models.Model):
    scene_number = models.IntegerField()
    title = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    done = models.BooleanField()
    artwork = models.ForeignKey(artwork,on_delete=models.CASCADE)
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)

class scene_actors(models.Model):
    scene = models.ForeignKey(scenes,on_delete=models.CASCADE)
    actor = models.ForeignKey(actor,on_delete=models.CASCADE)
    





