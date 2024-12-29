import 'package:get/get.dart';
import 'package:senior_app/actor_details/actor_details_controller.dart';

class ActorDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActorDetailsController>(() => ActorDetailsController());
  }
}
