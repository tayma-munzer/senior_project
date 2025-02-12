import 'package:get/get.dart';
import 'package:senior_app/Director/actors_artwork_details/actor_artwork_details_controller.dart';

class ActorArtworkDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActorArtworkDetailsController>(
        () => ActorArtworkDetailsController());
  }
}
