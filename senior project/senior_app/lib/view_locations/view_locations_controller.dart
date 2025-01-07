import 'package:get/get.dart';
import 'package:senior_app/favorite_locations/favorite_location_controller.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewLocationsController extends GetxController {
  var locationsList = <Map>[].obs;
  var searchQuery = ''.obs;
  final favoriteController = Get.put(FavoriteLocationController());

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('User token: $token');

    if (token == null) {
      print('Token is null, fetchLocations aborted.');
      return;
    }

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
            'id': location['id'],
            'location': location['location'],
            'detailed_address': location['detailed_address'],
            'desc': location['desc'] ?? 'No description',
            'building_owner': {
              'first_name': location['building_owner']['first_name'],
              'last_name': location['building_owner']['last_name'],
              'email': location['building_owner']['email'],
              'phone_number': location['building_owner']['phone_number'],
              'landline_number': location['building_owner']['landline_number'],
              'current_country': location['building_owner']['current_country'],
            },
            'building_style': location['building_style'] ?? 'Unknown',
            'building_type': location['building_type'] ?? 'Unknown',
            'images': location['images'] ?? [],
          };
        }).toList());
        print('Fetched locations: $locationsList');
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

  Future<void> toggleFavorite(Map location) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final locationId = location['id'];

    if (locationId == null || token == null) {
      print('Invalid location ID or user token');
      return;
    }

    try {
      final isFavorite = favoriteController.isFavorite(location);
      final url = 'http://10.0.2.2:8000/favoraites/$locationId';
      final response = isFavorite
          ? await http.delete(
              Uri.parse(url),
              headers: {'Authorization': 'Token $token'},
            )
          : await http.post(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Token $token',
              },
              body: json.encode({'location_id': locationId}),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isFavorite) {
          favoriteController.removeFavorite(location);
        } else {
          favoriteController.addFavorite(location);
        }
      } else {
        print('Failed to update favorite: ${response.body}');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }
}
