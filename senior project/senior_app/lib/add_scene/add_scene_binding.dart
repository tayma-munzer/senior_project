import 'package:get/get.dart';
import 'add_scene_controller.dart';

class AddSceneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSceneController>(() => AddSceneController());
  }
}
