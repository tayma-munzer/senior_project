import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_app/auth_controller.dart';

class AddSceneActorsController extends GetxController {
  // This will store the list of actors fetched from the API.
  var actors = <Map<String, dynamic>>[].obs;
  // A list to track the selection state for each actor.
  var selectedActors = <bool>[].obs;
  // A list to store the maps of the actors that are selected.
  var selectedActorList = <Map<String, dynamic>>[].obs;

  // For this example, the artwork ID is 26.
  // In a dynamic setup, you could retrieve this via Get.arguments or another method.
  int artworkId = 26;

  @override
  void onInit() {
    super.onInit();
    fetchActors();
  }

  Future<void> fetchActors() async {
    try {
      String? token = await AuthController().getToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token is missing. Please log in again.');
        return;
      }
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/actors'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        // Transform each API actor object into a map that fits our UI.
        actors.value = jsonResponse.map<Map<String, dynamic>>((item) {
          String firstName = item['actor']['first_name'] ?? '';
          String lastName = item['actor']['last_name'] ?? '';
          String name = "$firstName $lastName";
          String type = item['role_type']?['role_type'] ?? '';
          // Here, we use the date_of_birth as a placeholder for "age"
          String dob = item['actor']['additional_info']?['date_of_birth'] ?? '';
          // Get the personal image; if it starts with '/', prepend the server URL.
          String image = item['actor']['additional_info']?['personal_image'] ??
              'assets/login.png';
          if (image.startsWith('/')) {
            image = "http://10.0.2.2:8000" + image;
          }
          return {
            "name": name,
            "age": dob,
            "type": type,
            "image": image,
          };
        }).toList();
        // Initialize the selection list with a false value for each fetched actor.
        selectedActors.value =
            List<bool>.generate(actors.length, (index) => false);
      } else {
        Get.snackbar('Error', 'Failed to load actors: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching actors: $e");
      Get.snackbar('Error', 'An error occurred while fetching actors.');
    }
  }

  void toggleSelection(int index, bool value) {
    selectedActors[index] = value;

    if (value) {
      selectedActorList.add(actors[index]);
    } else {
      selectedActorList
          .removeWhere((actor) => actor['name'] == actors[index]['name']);
    }
  }

  void submitScene() {
    print("Selected Actors:");
    if (selectedActorList.isEmpty) {
      print("No actors selected.");
    } else {
      for (var actor in selectedActorList) {
        print(actor['name']);
      }
    }
  }

  void addActor() {
    print("Add actor tapped");
  }
}
