import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:senior_app/Director/director_home_page/director-home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddActorsToArtworkController extends GetxController {
  var actorsList = <Map>[].obs;
  var searchQuery = ''.obs;
  var userCountry = ''.obs;
  var selectedActorIds = <int>[].obs;
  var roleTypes = <Map>[].obs;

  var selectedRoles = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActors();
    fetchRoleTypes();
  }

  void toggleActorSelection(int actorId) {
    if (selectedActorIds.contains(actorId)) {
      selectedActorIds.remove(actorId);
      selectedRoles.remove(actorId);
    } else {
      selectedActorIds.add(actorId);
    }
  }

  Future<void> fetchRoleTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/role_types'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        roleTypes.assignAll(data.map((role) {
          return {
            'id': role['id'],
            'role_type': role['role_type'],
          };
        }).toList());
      } else {
        print('Failed to load role types: ${response.body}');
      }
    } catch (e) {
      print('Error fetching role types: $e');
    }
  }

  Future<void> fetchActors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/actors'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        actorsList.assignAll(data.map((actor) {
          final country = actor['additional_info']['current_country']
                  ['contry'] ??
              'Unknown';

          if (actor['email'] == prefs.getString('user_email')) {
            userCountry.value = country;
          }

          return {
            'id': actor['id'],
            'first_name': actor['first_name'],
            'last_name': actor['last_name'],
            'email': actor['email'],
            'phone_number': actor['phone_number'],
            'landline_number': actor['landline_number'],
            'availability': actor['additional_info']['available'],
            'country': country,
            'date_of_birth': actor['additional_info']['date_of_birth'],
            'personal_image': actor['additional_info']['personal_image'] ??
                '/media/default.jpg',
          };
        }).toList());
      } else {
        print('Failed to load actors: ${response.body}');
      }
    } catch (e) {
      print('Error fetching actors: $e');
    }
  }

  List<Map> filteredActors() {
    if (searchQuery.value.isEmpty) {
      return actorsList;
    }
    return actorsList.where((actor) {
      final fullName = '${actor['first_name']} ${actor['last_name']}';
      return fullName.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void selectRoleForActor(int actorId, int roleTypeId) {
    selectedRoles[actorId] = roleTypeId;
    if (!selectedActorIds.contains(actorId)) {
      selectedActorIds.add(actorId);
    }
  }

  void deselectActor(int actorId) {
    selectedRoles.remove(actorId);
    selectedActorIds.remove(actorId);
  }

  Future<void> submitActorsForArtwork(int artworkId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/artwork/$artworkId/actors');
    final payload = {
      "actors": selectedRoles.entries
          .map((entry) => {
                "actor_id": entry.key,
                "role_type_id": entry.value,
              })
          .toList()
    };

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $token",
          },
          body: json.encode(payload));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final DirectorHomeController homeController = Get.find();
        homeController.fetchArtworks();
        Get.toNamed('/directorHome');
      } else {
        Get.snackbar('Error', 'Failed to add actors to artwork');
        print("Response: ${response.body}");
      }
    } catch (e) {}
  }
}
