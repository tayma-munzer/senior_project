import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavoriteLocationController extends GetxController {
  var favoriteLocations = <Map>[].obs;

  void addFavorite(Map location) {
    if (!favoriteLocations.contains(location)) {
      favoriteLocations.add(location);
    }
  }

  void removeFavorite(Map location) {
    favoriteLocations.remove(location);
  }

  bool isFavorite(Map location) {
    return favoriteLocations.contains(location);
  }

  Future<void> deleteFavorite(Map location) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final locationId = location['id'];

    if (locationId == null || token == null) {
      print('Invalid location ID or user token');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/favoraites/$locationId'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        removeFavorite(location);
        print('Deleted location ID: $locationId');
      } else {
        print('Failed to delete favorite: ${response.body}');
      }
    } catch (e) {
      print('Error deleting favorite: $e');
    }
  }
}
