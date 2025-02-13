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
    path('artwork_gallary',views.artworkGallary),
    path('artwork_gallary/artwork/<int:pk>',views.artwork_from_artworkGallary),
    path('actor_acting_types',views.actorActingTypes),
    path('actor_acting_types/<int:pk>',views.deleteActorActingType),
    path('acting_types',views.acting_type_list),
    path('countries',views.countries_list),
    path('role_types',views.role_type_list),
    path('building_styles',views.building_style_list),
    path('building_types',views.building_type_list),
    path('actors',views.actors_list),
    path('location/<int:pk>/photos',views.location_image_list),
    path('location/photo/<int:pk>',views.location_image_detail),
    path('location/<int:pk>/photo',views.test_add_location_image),
    path('location/<int:pk>/videos',views.location_video_list),
    path('location/video/<int:pk>',views.location_video_detail),
    path('location/<int:pk>/video',views.test_add_location_video),
    path('personal_image',views.actor_image),
    path('official_document',views.add_official_doc),
    path('acting_request/<int:pk>/approve',views.acting_request_approve),
    path('acting_request/<int:pk>/reject',views.acting_request_reject),
    path('location_booking/<int:id>',views.booking_location),
    path('story_board',views.story_board),
    path('trailer',views.gettrailer),
    path('sync_lips',views.synclips),
    path('camera_location',views.cameraLocation),
    path('pending-actors/', views.pending_actors, name='pending_actors'),
    path('approve-actor/<int:actor_id>/', views.approve_actor, name='approve_actor'),
    path('reject-actor/<int:actor_id>/', views.reject_actor, name='reject_actor'),
]
