import 'package:get/get.dart';
import 'package:senior_app/auth_controller.dart';

class LoginController extends GetxController {
  String? email;
  String? password;

  final AuthController authController = Get.put(AuthController());

  String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) return "This field shouldn't be empty";

    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
      if (!GetUtils.isEmail(value)) {
        return "Invalid email format.";
      }
    } else {
      return "Invalid input.email.";
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
  Future<String?> login() async {
    if (email == null || password == null) return null;

    // Assuming `authenticateUser` returns a bool for success
    bool isAuthenticated =
        await authController.authenticateUser(email!, password!);
    if (isAuthenticated) {
      // Access the value of the RxString token
      return authController.token.value;
    }
    return null;
  }
}
