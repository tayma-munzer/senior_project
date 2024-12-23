import 'package:get/get.dart';
import 'package:senior_app/signup/sign_up_personal_information/sign_up_personal_information_controller.dart';

class SignUpPersonalInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpPersonalInformationController>(
        () => SignUpPersonalInformationController());
  }
}
