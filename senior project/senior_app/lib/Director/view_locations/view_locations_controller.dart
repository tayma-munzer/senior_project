import 'package:get/get.dart';
import 'package:senior_app/Director/favorite_locations/favorite_location_controller.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewLocationsController extends GetxController {
  var locationsList = <Map>[].obs;
  var searchQuery = ''.obs;
  var buildingStyle = ''.obs;
  var buildingType = ''.obs;
  final favoriteController = Get.put(FavoriteLocationController());

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations({
    String? search,
    String? buildingStyle,
    String? buildingType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final Uri uri =
          Uri.parse('http://10.0.2.2:8000/filming_location').replace(
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (buildingStyle != null && buildingStyle.isNotEmpty)
            'building_style': buildingStyle,
          if (buildingType != null && buildingType.isNotEmpty)
            'building_type': buildingType,
        },
      );

      final response = await http.get(
        uri,
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
            'photo': location['photo'] ?? '/media/images/default_location.jpg',
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

  List<Map> filteredLocation() {
    return locationsList.where((location) {
      final name = location['location'] ?? '';
      final matchesSearch = searchQuery.value.isEmpty ||
          name.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesBuildingStyle = buildingStyle.value.isEmpty ||
          (location['building_style']?['building_style'] ?? '')
              .toLowerCase()
              .contains(buildingStyle.value.toLowerCase());
      final matchesBuildingType = buildingType.value.isEmpty ||
          (location['building_type']?['building_type'] ?? '')
              .toLowerCase()
              .contains(buildingType.value.toLowerCase());
      return matchesSearch && matchesBuildingStyle && matchesBuildingType;
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
