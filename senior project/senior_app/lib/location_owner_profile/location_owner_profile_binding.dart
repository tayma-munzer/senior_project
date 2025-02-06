import 'package:get/get.dart';
import 'package:senior_app/director_profile/director_profile_controller.dart';
import 'package:senior_app/location_owner_profile/location_owner_profile_controller.dart';

class LocationOwnerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationOwnerProfileController());
  }
}
