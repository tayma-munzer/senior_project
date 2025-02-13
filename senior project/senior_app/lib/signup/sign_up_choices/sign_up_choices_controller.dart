import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SignUpChoicesController extends GetxController {
  var selectedChoice = ''.obs;

  void setChoice(String choice) {
    selectedChoice.value = choice;
  }

  String getRole() {
    switch (selectedChoice.value) {
      case 'ممثل':
        return 'actor';
      case 'مخرج':
        return 'director';
      case 'صاحب موقع':
        return 'location_owner';
      default:
        return '';
    }
  }
}
