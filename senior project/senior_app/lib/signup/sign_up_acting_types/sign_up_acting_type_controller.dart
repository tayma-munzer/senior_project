import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:senior_app/signup/sign_up/sign_up_controller.dart';
import 'package:senior_app/signup/sign_up_location/sign_up_location_controller.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';

class SignUpActingTypeController extends GetxController {
  var selectedActingType = ''.obs;
  RxList<Map<String, dynamic>> actingTypes = <Map<String, dynamic>>[].obs;
  var savedActingTypeIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActingTypes();
  }

  Future<void> registerActor() async {
    final personalInformationController =
        Get.find<SignUpPersonalInformationController>();
    final signUpController = Get.find<SignUpController>();

    final additionalInfo = {
      'current_country':
          Get.find<SignUpLocationController>().selectedCountry.value,
      'available': 'true',
      'approved': 'true',
      'date_of_birth': Get.find<SignUpLocationController>().birthDate,
    };

    await personalInformationController.registerUser(
      'actor',
      additionalInfo: additionalInfo,
      actingTypeIds: savedActingTypeIds.toList(),
      imageBytes: Get.find<SignUpLocationController>().selectedImageBytes.value,
    );
  }

  Future<void> fetchActingTypes() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/acting_types'));
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> actingTypeList = json.decode(decodedBody);
        actingTypes.value = actingTypeList
            .map((e) => {
                  'id': e['id'] as int,
                  'type': e['type'] as String,
                })
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load acting types');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching acting types');
      print(e);
    }
  }

  void saveActingType(int id) {
    if (!savedActingTypeIds.contains(id)) {
      savedActingTypeIds.add(id);
    }
  }

  void removeActingType(int id) {
    savedActingTypeIds.remove(id);
  }
}
