import 'package:get/get.dart';

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
