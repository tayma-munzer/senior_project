import 'package:get/get.dart';
import 'scene_details_controller.dart';

class SceneDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SceneDetailsController>(() => SceneDetailsController());
  }
}
