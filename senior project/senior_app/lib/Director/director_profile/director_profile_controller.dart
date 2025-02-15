import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_app/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectorProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString landlineNumber = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isEditing = false.obs;

  // Text controllers for editing
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final landlineNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    String? token = await authController.getToken();
    if (token != null) {
      isLoading.value = true;
      final userData = await authController.fetchUserProfile(token);
      if (userData != null) {
        firstName.value = userData['first_name'] ?? '';
        lastName.value = userData['last_name'] ?? '';
        email.value = userData['email'] ?? '';
        phoneNumber.value = userData['phone_number'].toString();
        landlineNumber.value = userData['landline_number'].toString();

        _updateTextFields();
      }
      isLoading.value = false;
    }
  }

  void _updateTextFields() {
    firstNameController.text = firstName.value;
    lastNameController.text = lastName.value;
    emailController.text = email.value;
    phoneNumberController.text = phoneNumber.value;
    landlineNumberController.text = landlineNumber.value;
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (isEditing.value) {
      _updateTextFields(); // Ensure text fields have up-to-date data
    }
  }

  Future<void> updateUserProfile() async {
    String? token = await authController.getToken();
    if (token == null) return;

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8000/profile"),
      headers: {
        "Authorization": "Token $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "phone_number": int.tryParse(phoneNumberController.text) ?? 0,
        "landline_number": int.tryParse(landlineNumberController.text) ?? 0
      }),
    );

    if (response.statusCode == 200) {
      fetchUserProfile();
      toggleEditing();
    }
  }
}
