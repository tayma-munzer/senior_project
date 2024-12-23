import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxString token = ''.obs;

  final String apiUrl = 'http://10.0.2.2:8000/login';

  Future<bool> authenticateUser(String emailOrPhone, String password) async {
    try {
      print("object22");
      print(emailOrPhone);
      print(password);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailOrPhone,
          'password': password,
        }),
      );
      print("object");

      if (response.statusCode == 200) {
        print("hiii");
        final Map<String, dynamic> data = json.decode(response.body);
        await saveToken(data['token']);
        return true;
      } else {
        print("llll");
        print(response.body);
        print(response.statusCode);
        Get.snackbar("Error", "Invalid credentials");
        return false;
      }
    } catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    this.token.value = token;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    token.value = '';
  }
}
