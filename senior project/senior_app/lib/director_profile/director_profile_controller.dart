import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DirectorPersonalProfileController extends GetxController {
  var isLoading = true.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No token found. Please login again.');
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/profile'),
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        userData.value = json.decode(response.body);
      } else {
        print("Error fetching profile: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(String field, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No token found. Please login again.');
      }

      final updatedData = Map<String, dynamic>.from(userData);
      updatedData[field] = value;

      print('Updated Data: $updatedData');

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(updatedData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        userData.value = json.decode(response.body);
        print('Profile updated successfully: ${userData.value}');
      } else {
        print("Error updating profile: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
