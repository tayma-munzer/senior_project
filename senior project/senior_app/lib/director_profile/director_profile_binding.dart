import 'package:get/get.dart';
import 'package:senior_app/director_profile/director_profile_controller.dart';

class DirectorPersonalProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DirectorPersonalProfileController());
  }
}
