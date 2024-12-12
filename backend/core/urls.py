from django.urls import path
from . import views

urlpatterns = [
    path('register',views.register),
    path('login',views.login),
    path('artwork',views.artwork_list),
    path('artwork/<int:pk>',views.artwork_detail),
    path('scene',views.add_scene),
    path('scene/<int:pk>',views.scene_detail),
    path('artwork/<int:pk>/scenes',views.artwork_scenes),
    path('filming_location',views.filming_location_list),
    path('filming_location/<int:pk>',views.filming_location_detail),
    path('my_filming_locations',views.owner_filming_locations),
    path('artwork/<int:pk>/done',views.artwork_done),
    path('scene/<int:pk>/done',views.scene_done),
    path('scene/<int:pk>/location',views.scene_location),
    path('artwork/<int:pk>/actors',views.artworkactors),
    path('scene/<int:pk>/actors',views.sceneactors),
    path('favoraites',views.owner_favoraites),
    path('favoraites/<int:pk>',views.favoraite_location),
    path('profile',views.user_profile),
    path('additional_info',views.additional_info),
]
