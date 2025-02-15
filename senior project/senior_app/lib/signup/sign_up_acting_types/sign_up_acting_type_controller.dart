import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:senior_app/signup/sign_up/sign_up_controller.dart';
import 'package:senior_app/signup/sign_up_location/sign_up_location_controller.dart';
import 'dart:convert';

import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';

class SignUpActingTypeController extends GetxController {
  var selectedActingType = ''.obs;
  RxList<String> actingTypes = <String>[].obs;
  var savedActingTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActingTypes();
  }

  Future<void> fetchActingTypes() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/acting_types'));
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> actingTypeList = json.decode(decodedBody);
        actingTypes.value =
            actingTypeList.map((e) => e['type'] as String).toList();
      } else {
        Get.snackbar('Error', 'Failed to load acting types');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching acting types');
      print(e);
    }
  }

  void saveActingType(String type) {
    if (!savedActingTypes.contains(type)) {
      savedActingTypes.add(type);
    }
  }

  void removeActingType(String type) {
    savedActingTypes.remove(type);
  }

  bool isUserActor() {
    return true;
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
      'acting_types': savedActingTypes.toList(),
    };

    await personalInformationController.registerUser('actor',
        additionalInfo: additionalInfo);
  }
}
