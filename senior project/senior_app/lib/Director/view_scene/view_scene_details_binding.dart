import 'package:get/get.dart';
import 'view_scene_details_controller.dart';

class ViewSceneDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewSceneDetailsController>(() => ViewSceneDetailsController());
  }
}
