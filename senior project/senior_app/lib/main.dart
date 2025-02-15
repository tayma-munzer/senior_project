import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/Director/AI/camera/camera_binding.dart';
import 'package:senior_app/Director/AI/camera/camera_view.dart';
import 'package:senior_app/Director/AI/chroma/chroma_binding.dart';
import 'package:senior_app/Director/AI/chroma/chroma_view.dart';
import 'package:senior_app/Director/AI/lip%20sync/lip_sync_binding.dart';
import 'package:senior_app/Director/AI/lip%20sync/lip_sync_view.dart';
import 'package:senior_app/Director/AI/story%20board/story_board_binding.dart';
import 'package:senior_app/Director/AI/story%20board/story_board_view.dart';
import 'package:senior_app/Director/AI/trailer%20generate/trailergenerate_binding.dart';
import 'package:senior_app/Director/AI/trailer%20generate/trailergenerate_view.dart';
import 'package:senior_app/Director/actors_artwork_details/actor_artwork_details_binding.dart';
import 'package:senior_app/Director/actors_artwork_details/actor_artwork_details_view.dart';
import 'package:senior_app/Director/add_actors_to_artwork/add_actors_to_artwork_binding.dart';
import 'package:senior_app/Director/add_actors_to_artwork/add_actors_to_artwork_view.dart';
import 'package:senior_app/Director/artwork_details/editartworkView.dart';
import 'package:senior_app/Director/scene_details/scene_details_binding.dart';
import 'package:senior_app/Director/scene_details/scene_details_view.dart';
import 'package:senior_app/Location%20Owner/add_video_to_filming_location/add_video_to_filming_location_binding.dart';
import 'package:senior_app/Location%20Owner/add_video_to_filming_location/add_video_to_filming_location_view.dart';
import 'package:senior_app/auth_controller.dart';
import 'package:senior_app/Actors/view_actore_artwork/view_actor_artwork_gallary_binding.dart';
import 'package:senior_app/Actors/view_actore_artwork/view_actor_artwork_gallery_view.dart';
import 'package:senior_app/Actors/view_details_artwork_gallary/artwork_gallary_details_binding.dart';
import 'package:senior_app/Actors/view_details_artwork_gallary/artwork_gallary_details_view.dart';
import 'package:senior_app/Actors/view_profile/view_actor_profile_binding.dart';
import 'package:senior_app/Actors/view_profile/view_actor_profile_view.dart';
import 'package:senior_app/Director/actor_details/actor_details_binding.dart';
import 'package:senior_app/Director/actor_details/actor_details_view.dart';
import 'package:senior_app/Location%20Owner/add%20photos%20to%20filming%20location/add_photos_filminglocation_binding.dart';
import 'package:senior_app/Location%20Owner/add%20photos%20to%20filming%20location/add_photos_filminglocation_view.dart';
import 'package:senior_app/Director/add_artwork/add_artwork_poster_binding.dart';
import 'package:senior_app/Director/add_artwork/add_artwork_poster_view.dart';
import 'package:senior_app/Director/add_days/add_days_binding.dart';
import 'package:senior_app/Director/add_days/add_days_view.dart';
import 'package:senior_app/Director/add_location/add_location_binding.dart';
import 'package:senior_app/Director/add_location/add_location_view.dart';
import 'package:senior_app/Director/add_scene_actors/add_scene_actors_binding.dart';
import 'package:senior_app/Director/add_scene_actors/add_scene_actors_view.dart';
import 'package:senior_app/Director/artwork_details/artwork_details_bindings.dart';
import 'package:senior_app/Director/artwork_details/artwork_details_view.dart';
import 'package:senior_app/Director/director_home_page/director-home_binding.dart';
import 'package:senior_app/Director/director_home_page/director-home_view.dart';
import 'package:senior_app/Director/director_profile/director_profile_binding.dart';
import 'package:senior_app/Director/director_profile/director_profile_view.dart';
import 'package:senior_app/Director/favorite_locations/favorite_location_view.dart';
import 'package:senior_app/Director/favorite_locations/favorite_locations_binding.dart';
import 'package:senior_app/Location%20Owner/location%20filming%20owner/add%20location/add_filming_location_binding.dart';
import 'package:senior_app/Location%20Owner/location%20filming%20owner/add%20location/add_filming_location_view.dart';
import 'package:senior_app/Director/location_details/location_details_binding.dart';
import 'package:senior_app/Director/location_details/location_details_view.dart';
import 'package:senior_app/Location%20Owner/location_owner_profile/location_owner_profile_binding.dart';
import 'package:senior_app/Location%20Owner/location_owner_profile/location_owner_profile_view.dart';
import 'package:senior_app/login/login_binding.dart';
import 'package:senior_app/login/login_view.dart';
import 'package:senior_app/signup/sign_up/sign_up_binding.dart';
import 'package:senior_app/signup/sign_up/sign_up_view.dart';
import 'package:senior_app/signup/sign_up_acting_types/sign_up_acting_type_binding.dart';
import 'package:senior_app/signup/sign_up_acting_types/sign_up_acting_types_view.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_binding.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_view.dart';
import 'package:senior_app/signup/sign_up_location/sign_up_location_binding.dart';
import 'package:senior_app/signup/sign_up_location/sign_up_location_view.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_binding.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_view.dart';
import 'package:senior_app/Director/view_actors/view_actors_binding.dart';
import 'package:senior_app/Director/view_actors/view_actors_view.dart';
import 'package:senior_app/Location%20Owner/view_filming_owner_locations/view_filming_locations_owner_binding.dart';
import 'package:senior_app/Location%20Owner/view_filming_owner_locations/view_filming_locations_owner_view.dart';
import 'package:senior_app/Location%20Owner/view_location_owner_details/edit_location_owner_view.dart';
import 'package:senior_app/Location%20Owner/view_location_owner_details/view_location_details_binding.dart';
import 'package:senior_app/Location%20Owner/view_location_owner_details/view_location_details_view.dart';
import 'package:senior_app/Director/view_locations/view_locations_binding.dart';
import 'package:senior_app/Director/view_locations/view_locations_view.dart';
import 'package:senior_app/Director/view_scene/view_scene_details_binding.dart';
import 'package:senior_app/Director/view_scene/view_scene_details_view.dart';
import 'package:senior_app/welcome/welcom_view.dart';
import 'package:senior_app/welcome/welcome_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register the AuthController so that it is available globally
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cinema Director Assistance',
      initialRoute: '/login',
      getPages: [
        GetPage(
            name: '/login', page: () => LoginView(), binding: LoginBinding()),
        GetPage(
            name: '/signupchoices',
            page: () => SignUpChoicesView(),
            binding: SignUpChoicesBinding()),
        GetPage(
            name: '/signuplocation',
            page: () => SignUpLocationView(),
            binding: SignUpLocationBinding()),
        GetPage(
            name: '/favoritelocations',
            page: () => FavoriteLocationView(),
            binding: FavoriteLocationBinding()),
        GetPage(
            name: '/signuppersonalinformation',
            page: () => SignUpPersonalInformationView(),
            binding: SignUpPersonalInformationBinding()),
        GetPage(
            name: '/signupactingtypes',
            page: () => SignUpActingTypeView(),
            binding: SignUpActingTypeBinding()),
        GetPage(
            name: '/signup',
            page: () => SignUpView(),
            binding: SignUpBinding()),
        GetPage(
            name: '/directorHome',
            page: () => DirectorHomeView(),
            binding: DirectorHomeBinding()),
        GetPage(
            name: '/artworkDetails',
            page: () => ArtworkDetailsView(),
            binding: ArtworkDetailsBinding()),
        GetPage(
            name: '/addscene',
            page: () => AddSceneActorsView(),
            binding: AddSceneActorsBinding()),
        GetPage(
            name: '/addfilminglocation',
            page: () => AddFilmingLocationView(),
            binding: AddFilmingLocationBinding()),
        GetPage(
          name: '/adddays',
          page: () => AddDaysView(),
          binding: AddDaysBinding(),
        ),
        GetPage(
          name: '/viewscenedetails',
          page: () => ViewSceneDetailsView(),
          binding: ViewSceneDetailsBinding(),
        ),
        GetPage(
            name: '/viewactors',
            page: () => ViewActorsView(),
            binding: ViewActorsBinding()),
        GetPage(
            name: '/actorsdetails',
            page: () => ActorDetailsView(),
            binding: ActorDetailsBinding()),
        GetPage(
            name: '/locationdetails',
            page: () => ViewLocationDetailsView(),
            binding: ViewLocationDetailsBinding()),
        GetPage(
            name: '/viewlocations',
            page: () => ViewLocationsView(),
            binding: ViewLocationsBinding()),
        GetPage(
          name: '/favorites',
          page: () => FavoriteLocationView(),
          binding: FavoriteLocationBinding(),
        ),
        GetPage(
          name: '/directorpersonalaccount',
          page: () => DirectorProfileView(),
          binding: DirectorProfileBinding(),
        ),
        GetPage(
          name: '/locationownerprofile',
          page: () => LocationOwnerProfileView(),
          binding: LocationOwnerProfileBinding(),
        ),
        GetPage(
          name: '/addartworkposter',
          page: () => AddArtworkPosterView(),
          binding: AddArtworkPosterBinding(),
        ),
        GetPage(
            name: '/addfilminglocation',
            page: () => AddFilmingLocationView(),
            binding: AddFilmingLocationBinding()),
        GetPage(
            name: '/addphotostofilminglocation',
            page: () => AddPhotoFilmingLocationView(),
            binding: AddPhotoFilmingLocationBinding()),
        GetPage(
            name: '/locationHome',
            page: () => ViewOwnerFilmingLocationView(),
            binding: ViewOwnerFilmingLocationBinding()),
        GetPage(
            name: '/welcome',
            page: () => WelcomeView(),
            binding: WelcomeBinding()),
        GetPage(
          name: '/locationownerdetails',
          page: () => ViewLocationOwnerLocationDetailsView(),
          binding: ViewLocationOwnerLocationDetailsBinding(),
        ),
        GetPage(
          name: '/editlocationowner',
          page: () => EditLocationOwnerView(),
        ),
        GetPage(
          name: '/actorHome',
          page: () => ViewActorArtworkGalleryView(),
          binding: ViewActorArtworkGallaryBinding(),
        ),
        GetPage(
          name: '/actorprofile',
          page: () => ViewActorProfileView(),
          binding: ViewActorProfileBinding(),
        ),
        GetPage(
          name: '/artworkdetails',
          page: () => ArtworkGallaryDetailsView(),
          binding: ArtworkGallaryDetailsBinding(),
        ),
        GetPage(
          name: '/addvideostofilminglocation',
          page: () => AddVideoToFilmingLocationView(),
          binding: AddVideoToFilmingLocationBinding(),
        ),
        GetPage(
          name: '/addactorstoartwork',
          page: () => AddActorsToArtworkView(),
          binding: AddActorsToArtworkBinding(),
        ),
        //actorsdetailsartwork
        GetPage(
          name: '/actorsdetailsartwork',
          page: () => ActorArtworkDetailsView(),
          binding: ActorArtworkDetailsBinding(),
        ),
        GetPage(
          name: '/addlocationtoartwork',
          page: () => AddLocationView(),
          binding: AddLocationBinding(),
        ),
        GetPage(
          name: '/addsceneactors',
          page: () => AddSceneActorsView(),
          binding: AddSceneActorsBinding(),
        ),
        GetPage(
          name: '/getscenedetails',
          page: () => SceneDetailsView(),
          binding: SceneDetailsBinding(),
        ),

        GetPage(
          name: '/chroma',
          page: () => ChromaView(),
          binding: ChromaBinding(),
        ),
        GetPage(
          name: '/trailergenerator',
          page: () => TrailergeneraterView(),
          binding: TrailergeneraterBinding(),
        ),
        GetPage(
          name: '/camera',
          page: () => CameraView(),
          binding: CameraBinding(),
        ),
        GetPage(
          name: '/lipsync',
          page: () => LipSyncView(),
          binding: LipSyncBinding(),
        ),
        GetPage(
          name: '/storyboard',
          page: () => StoryBoardView(),
          binding: StoryBoardBinding(),
        ),
      ],
    );
  }
}
