// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/add_scene/add_scene_binding.dart';
import 'package:senior_app/add_scene/add_scene_view.dart';
import 'package:senior_app/artwork_details/artwork_details_bindings.dart';
import 'package:senior_app/artwork_details/artwork_details_view.dart';
import 'package:senior_app/director_home_page/director-home_binding.dart';
import 'package:senior_app/director_home_page/director-home_view.dart';
import 'package:senior_app/login/login_binding.dart';
import 'package:senior_app/login/login_view.dart';

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
            name: '/directorHome',
            page: () => DirectorHomeView(),
            binding: DirectorHomeBinding()),
        GetPage(
            name: '/artworkDetails',
            page: () => ArtworkDetailsView(),
            binding: ArtworkDetailsBinding()),
        GetPage(
            name: '/addscene',
            page: () => AddSceneView(),
            binding: AddSceneBinding()),
      ],
    );
  }
}
