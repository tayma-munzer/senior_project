import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewLocationsController extends GetxController {
  var locationsList = <Map>[].obs;
  var selectedLocations = <Map>[].obs;
  var searchQuery = ''.obs;
  var favoriteStates = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/filming_location'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        locationsList.assignAll(data.map((location) {
          return {
            'location': location['location'],
            'detailed_address': location['detailed_address'],
            'building_owner': {
              'first_name': location['building_owner']['first_name'],
              'last_name': location['building_owner']['last_name'],
            },
            'building_style':
                location['building_style']['building_style'] ?? 'Unknown',
            'building_type': location['building_type'],
          };
        }).toList());

        // Initialize favoriteStates to match the length of locationsList
        favoriteStates
            .assignAll(List.generate(locationsList.length, (_) => false));
      } else {
        print('Failed to load locations: ${response.body}');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  List<Map> filteredLocations() {
    if (searchQuery.value.isEmpty) {
      return locationsList;
    }
    return locationsList.where((location) {
      final name = location['location'] ?? '';
      return name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleLocationSelection(Map location) {
    if (selectedLocations.contains(location)) {
      selectedLocations.remove(location);
    } else {
      selectedLocations.add(location);
    }
  }

  bool isLocationSelected(Map location) {
    return selectedLocations.contains(location);
  }

  void toggleFavorite(int index) {
    if (index < 0 || index >= favoriteStates.length) {
      print('Invalid index for favoriteStates: $index');
      return;
    }
    favoriteStates[index] = !favoriteStates[index];
  }

  bool isFavorite(int index) {
    if (index < 0 || index >= favoriteStates.length) {
      print('Invalid index for favoriteStates: $index');
      return false;
    }
    return favoriteStates[index];
  }
}
