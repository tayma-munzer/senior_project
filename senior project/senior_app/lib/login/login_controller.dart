import 'package:get/get.dart';
import 'package:senior_app/auth_controller.dart';

class LoginController extends GetxController {
  String? emailOrPhone;
  String? password;

  final AuthController authController = Get.put(AuthController());

  String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) return "This field shouldn't be empty";

    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      if (!GetUtils.isEmail(value)) {
        return "Invalid email format.";
      }
    } else if (RegExp(r'^[0-9]+$').hasMatch(value)) {
      if (value.length != 10 || !value.startsWith('09')) {
        return "Phone number should start with '09' and be 10 digits long.";
      }
    } else {
      return "Invalid input. Please enter a valid phone number or email.";
    }

    return null;
  }

  String? validatePassword(String? value) {
    return (value == null || value.isEmpty)
        ? "This field shouldn't be empty"
        : null;
  }

  bool validateForm() {
    return true;
  }

  // Method to login the user using AuthController
  Future<bool> login() async {
    if (emailOrPhone == null || password == null) return false;
    return await authController.authenticateUser(emailOrPhone!, password!);
  }
}
