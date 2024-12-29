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
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    if (!isUserActor()) {
      Get.offNamed('/login');
    }
  }
}
