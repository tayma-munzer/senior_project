import 'package:get/get.dart';
import 'package:senior_app/signup/sign_up_choices/sign_up_choices_controller.dart';

class SignUpChoicesBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the controller here
    Get.lazyPut<SignUpChoicesController>(() => SignUpChoicesController());
  }
}
