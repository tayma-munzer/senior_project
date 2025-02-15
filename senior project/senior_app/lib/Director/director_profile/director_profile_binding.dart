import 'package:get/get.dart';
import 'package:senior_app/Director/director_profile/director_profile_controller.dart';

class DirectorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectorProfileController>(() => DirectorProfileController());
  }
}
