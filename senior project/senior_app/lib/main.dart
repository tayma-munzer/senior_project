import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/actor_details/actor_details_binding.dart';
import 'package:senior_app/actor_details/actor_details_view.dart';
import 'package:senior_app/add_artwork/add_artwork_poster_binding.dart';
import 'package:senior_app/add_artwork/add_artwork_poster_view.dart';
import 'package:senior_app/add_days/add_days_binding.dart';
import 'package:senior_app/add_days/add_days_view.dart';
import 'package:senior_app/add_location/add_location_binding.dart';
import 'package:senior_app/add_location/add_location_view.dart';
import 'package:senior_app/add_scene/add_scene_actors_binding.dart';
import 'package:senior_app/add_scene/add_scene_actors_view.dart';
import 'package:senior_app/artwork_details/artwork_details_bindings.dart';
import 'package:senior_app/artwork_details/artwork_details_view.dart';
import 'package:senior_app/director_home_page/director-home_binding.dart';
import 'package:senior_app/director_home_page/director-home_view.dart';
import 'package:senior_app/director_profile/director_profile_binding.dart';
import 'package:senior_app/director_profile/director_profile_view.dart';
import 'package:senior_app/favorite_locations/favorite_location_view.dart';
import 'package:senior_app/favorite_locations/favorite_locations_binding.dart';
import 'package:senior_app/location_details/location_details_binding.dart';
import 'package:senior_app/location_details/location_details_view.dart';
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
import 'package:senior_app/view_actors/view_actors_binding.dart';
import 'package:senior_app/view_actors/view_actors_view.dart';
import 'package:senior_app/view_locations/view_locations_binding.dart';
import 'package:senior_app/view_locations/view_locations_view.dart';
import 'package:senior_app/view_scene/view_scene_details_binding.dart';
import 'package:senior_app/view_scene/view_scene_details_view.dart';

void main() {
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
            name: '/addlocation',
            page: () => AddLocationView(),
            binding: AddLocationBinding()),
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
          page: () => DirectorPersonalProfileView(),
          binding: DirectorPersonalProfileBinding(),
        ),
        GetPage(
          name: '/addartworkposter',
          page: () => AddArtworkPosterView(),
          binding: AddArtworkPosterBinding(),
        ),
      ],
    );
  }
}
