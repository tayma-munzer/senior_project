import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:senior_app/auth_controller.dart';

class ArtworkDetailsController extends GetxController {
  var actors = <Actor>[].obs;
  var scenes = <Scene>[].obs;
  var isLoading = false.obs;
  late int artworkId;

  @override
  void onInit() {
    artworkId = Get.arguments;
    fetchActors();
    super.onInit();
  }

  Future<void> fetchActors() async {
    try {
      isLoading(true);
      String? token = await AuthController().getToken();
      if (token == null) {
        print("Error: User token is null");
        return;
      }

      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/actors'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        actors.value = data.map((item) {
          return Actor(
            id: item['actor']['id'],
            firstName: item['actor']['first_name'],
            lastName: item['actor']['last_name'],
          );
        }).toList();
      } else {
        print("Error fetching actors: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteActor(Actor actor) {
    actors.remove(actor);
  }

  void addScene(String title) {
    scenes.add(Scene(title: title));
  }

  void deleteScene(Scene scene) {
    scenes.remove(scene);
  }
}

class Actor {
  final int id;
  final String firstName;
  final String lastName;

  Actor({required this.id, required this.firstName, required this.lastName});
}

class Scene {
  final String title;

  Scene({required this.title});
}
