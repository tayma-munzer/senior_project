import 'package:get/get.dart';
import 'sign_up_location_controller.dart';

class SignUpLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpLocationController>(() => SignUpLocationController());
  }
}
