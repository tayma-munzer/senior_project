import 'package:get/get.dart';
import 'package:senior_app/Actors/view_actore_artwork/view_actor_artwork_gallary_controller.dart';

class ViewActorArtworkGallaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewActorArtworkGallaryController());
  }
}
