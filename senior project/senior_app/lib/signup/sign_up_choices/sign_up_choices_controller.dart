import 'package:get/get.dart';

class SignUpChoicesController extends GetxController {
  var selectedChoice = ''.obs;

  void setChoice(String choice) {
    selectedChoice.value = choice;
  }
}
