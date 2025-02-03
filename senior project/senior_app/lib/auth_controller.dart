import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxString token = ''.obs;

  final String apiUrl = 'http://10.0.2.2:8000/login'; // Updated API URL
  final String profileUrl =
      'http://10.0.2.2:8000/profile'; // Updated Profile URL

  Future<bool> authenticateUser(String email, String password) async {
    try {
      print('Authenticating with email: $email, password: $password');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Authentication successful');
        final Map<String, dynamic> data = json.decode(response.body);
        token.value = data['token']; // Save the token
        await saveToken(data['token']); // Save token to SharedPreferences
        return true;
      } else {
        print('Authentication failed: ${response.body}');
        Get.snackbar('Error', 'Invalid credentials');
        return false;
      }
    } catch (e) {
      print('Error during authentication: $e');
      Get.snackbar('Error', 'An error occurred during authentication');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token.value = '';
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        print('User profile fetched successfully');
        return json.decode(response.body);
      } else {
        print('Failed to fetch user profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
