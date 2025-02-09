import 'package:get/get.dart';
import 'view_actor_profile_controller.dart';

class ViewActorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewActorProfileController>(() => ViewActorProfileController());
  }
}
