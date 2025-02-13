from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models

# Create your models here.

class countries(models.Model):
    contry = models.CharField(max_length=255)

class ActingType(models.Model):
    type = models.CharField(max_length=255)

class CustomUserManager(BaseUserManager):
    def create_User(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superUser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_User(email, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    role = models.CharField(max_length=255)
    phone_number = models.IntegerField()
    landline_number = models.IntegerField()
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email' 
    REQUIRED_FIELDS = ['first_name','last_name','role','phone_number','landline_number']

    def __str__(self):
        return self.email

class RoleType(models.Model):
    role_type = models.CharField(max_length=255)

class BuildingStyle(models.Model):
    building_style = models.CharField(max_length=255)

    def __str__(self):
        return self.building_style

class BuildingType(models.Model):
    building_type = models.CharField(max_length=255)

    def __str__(self):
        return self.building_type

class actor_additional_info(models.Model):
    actor = models.ForeignKey(User, related_name='additional_info',on_delete=models.CASCADE)
    current_country = models.ForeignKey(countries,on_delete=models.CASCADE)
    available = models.BooleanField(default=False)
    approved = models.BooleanField(default=False)
    personal_image = models.ImageField(upload_to='personal_image/',default='personal_image/default.jpg')
    date_of_birth = models.DateField(auto_now_add=True)

class official_document(models.Model):
    document = models.FileField(upload_to='documents/')
    actor = models.ForeignKey(User,on_delete=models.CASCADE)

class actor_acting_types(models.Model):
    actor = models.ForeignKey(User,on_delete=models.CASCADE)
    acting_type= models.ForeignKey(ActingType,on_delete=models.CASCADE)

class artwork_gallery(models.Model):
    actor = models.ForeignKey(User,on_delete=models.CASCADE)
    artwork_name = models.CharField(max_length=255)
    poster = models.ImageField(upload_to='images/')
    character_name = models.CharField(max_length=255)
    role_type = models.ForeignKey(RoleType,on_delete=models.CASCADE)

class artwork(models.Model):
    title = models.CharField(max_length=255)
    poster = models.ImageField(upload_to='images/')
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    done = models.BooleanField(default=False)

class artwork_actors(models.Model):
    actor = models.ForeignKey(User,on_delete=models.CASCADE)
    artwork = models.ForeignKey(artwork,on_delete=models.CASCADE)
    role_type = models.ForeignKey(RoleType,on_delete=models.CASCADE)
    approved = models.BooleanField(default=False)

class filming_location(models.Model):
    location = models.CharField(max_length=255)
    detailed_address = models.CharField(max_length=255)
    desc = models.CharField(max_length=255)
    building_style = models.ForeignKey(BuildingStyle,on_delete=models.CASCADE)
    building_type = models.ForeignKey(BuildingType,on_delete=models.CASCADE)
    building_owner = models.ForeignKey(User,on_delete=models.CASCADE)
    
class booking_dates(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    date = models.DateField()

class location_photos(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    photo = models.ImageField(upload_to='images/')

class location_videos(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    video = models.FileField(upload_to='videos/')

class favoraites(models.Model):
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE)
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    
class scenes(models.Model):
    scene_number = models.IntegerField()
    title = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    done = models.BooleanField(default=False)
    artwork = models.ForeignKey(artwork,on_delete=models.CASCADE)
    location = models.ForeignKey(filming_location,on_delete=models.CASCADE,null=True)

class scene_actors(models.Model):
    scene = models.ForeignKey(scenes,on_delete=models.CASCADE)
    actor = models.ForeignKey(User,on_delete=models.CASCADE)

class story_board(models.Model):
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    prompt = models.CharField(max_length=255)
    image_base64 = models.ImageField(upload_to='story_board/')

class trailer(models.Model):
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    video_url = models.CharField(max_length=255)
    trailer = models.FileField(upload_to='trailer/')
    video_duration = models.IntegerField()
    num_scenes=models.IntegerField()
    text_idea = models.CharField(max_length=255)

class sync_lips(models.Model):
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    video = models.FileField(upload_to='sync_lips_input/')
    text = models.CharField(max_length=255)
    generated_video = models.FileField(upload_to='sync_lips_output/')
    

class camera_location(models.Model):
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    video = models.FileField(upload_to='camera_location_input/')
    generated_video = models.FileField(upload_to='camera_location_output/')
    
class chroma(models.Model):
    director = models.ForeignKey(User,on_delete=models.CASCADE)
    prompt = models.CharField(max_length=255)
    file = models.FileField(upload_to='chroma_input/')
    generated_image = models.ImageField(upload_to='chroma_output/')



