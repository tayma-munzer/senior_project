import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../sign_up/sign_up_controller.dart';

class SignUpPersonalInformationController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var phoneNumber = ''.obs;
  var landlineNumber = ''.obs;

  void saveInformation(
      String fName, String lName, String phone, String landline) {
    firstName.value = fName;
    lastName.value = lName;
    phoneNumber.value = phone;
    landlineNumber.value = landline;

    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Phone Number: $phoneNumber');
    print('Landline Number: $landlineNumber');
  }

  Future<void> registerUser(String role,
      {Map<String, dynamic>? additionalInfo}) async {
    final url = Uri.parse('http://10.0.2.2:8000/register');
    final headers = {'Content-Type': 'application/json'};

    final body = {
      'first_name': firstName.value,
      'last_name': lastName.value,
      'email': Get.find<SignUpController>().email,
      'password': Get.find<SignUpController>().password,
      'role': role,
      'phone_number': phoneNumber.value,
      'landline_number': landlineNumber.value,
    };

    if (role == 'actor' && additionalInfo != null) {
      body['additional_info'] =
          json.encode(additionalInfo); // Encode the map as JSON
    }

    try {
      final response =
          await http.post(url, headers: headers, body: json.encode(body));
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        // Save the token (e.g., in shared preferences or GetX storage)
        print('Token: $token');
        Get.offNamed('/directorHome'); // Navigate to the home page
      } else {
        Get.snackbar('Error', 'Failed to register: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
