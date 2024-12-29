import 'package:get/get.dart';
import 'package:senior_app/signup/sign_up_acting_types/sign_up_acting_type_controller.dart';
import 'sign_up_acting_type_controller.dart';

class SignUpActingTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpActingTypeController());
  }
}
