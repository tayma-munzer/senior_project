import 'package:get/get.dart';

class SignUpActingTypeController extends GetxController {
  var selectedActingType = ''.obs;
  var actingTypes = [
    'Drama',
    'Romance',
    'Action',
    'Comedy',
    'Thriller',
    'Horror',
    // Add more acting types as needed
  ];
  var savedActingTypes = <String>[].obs;

  void saveActingType(String type) {
    if (!savedActingTypes.contains(type)) {
      savedActingTypes.add(type);
    }
  }

  void removeActingType(String type) {
    savedActingTypes.remove(type);
  }

  bool isUserActor() {
    // Check user role logic - for demo, assume it's hardcoded
    return true; // Replace with actual user role check
  }

  @override
  void onInit() {
    super.onInit();
    if (!isUserActor()) {
      Get.offNamed('/login');
    }
  }
}
