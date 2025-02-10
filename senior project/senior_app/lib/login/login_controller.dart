import 'package:get/get.dart';
import 'package:senior_app/auth_controller.dart';

class LoginController extends GetxController {
  String? email;
  String? password;

  final AuthController authController = Get.put(AuthController());

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "This field shouldn't be empty";
    if (!GetUtils.isEmail(value)) return "Invalid email format.";
    return null;
  }

  String? validatePassword(String? value) {
    return (value == null || value.isEmpty)
        ? "This field shouldn't be empty"
        : null;
  }

  Future<void> login() async {
    if (email == null || password == null) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    bool isAuthenticated =
        await authController.authenticateUser(email!, password!);
    if (isAuthenticated) {
      final token = authController.token.value;
      print("User token: $token");

      final profile = await authController.fetchUserProfile(token);
      if (profile != null && profile.containsKey('role')) {
        final role = profile['role'];
        if (role == 'actor') {
          Get.offNamed('/actorprofile');
        } else if (role == 'director') {
          Get.offNamed('/directorHome');
        } else if (role == 'location_owner') {
          Get.offNamed('/locationHome');
        } else {
          Get.snackbar('Error', 'Unauthorized user role');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile');
      }
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }
}
