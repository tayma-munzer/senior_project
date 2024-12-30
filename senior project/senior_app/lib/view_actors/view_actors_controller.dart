import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewActorsController extends GetxController {
  var actorsList = <Map>[].obs;
  var selectedActors = <Map>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActors();
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
        actorsList.assignAll(data
            .map((actor) => {
                  'first_name': actor['first_name'],
                  'last_name': actor['last_name'],
                  'current_country': actor['current_country'],
                  'availability': actor['availability'],
                })
            .toList());
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

  void toggleActorSelection(Map actor) {
    if (selectedActors.contains(actor)) {
      selectedActors.remove(actor);
    } else {
      selectedActors.add(actor);
    }
  }

  bool isActorSelected(Map actor) {
    return selectedActors.contains(actor);
  }
}
