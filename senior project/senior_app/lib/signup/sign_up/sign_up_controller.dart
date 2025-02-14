import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:senior_app/signup/sign_up_acting_types/sign_up_acting_type_controller.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var email = '';
  var password = '';
  var confirmPassword = '';

  final formKey = GlobalKey<FormState>();

  void saveSignUp() {
    if (formKey.currentState!.validate()) {
      email = emailController.text;
      password = passwordController.text;
      print('Email: $email, Password: $password');
    }
  }

  bool isPasswordVisible = false;
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  bool isConfirmPasswordVisible = false;
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  Future<void> registerUser() async {
    final personalInformationController =
        Get.find<SignUpPersonalInformationController>();
    final choiceController = Get.find<SignUpChoicesController>();

    final role = choiceController.getRole();

    if (role == 'actor') {
      // If the user is an actor, call the registerActor method
      await Get.find<SignUpActingTypeController>().registerActor();
    } else {
      // For other roles, call the registerUser method in SignUpPersonalInformationController
      await personalInformationController.registerUser(role);
    }
  }
}
