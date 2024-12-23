import 'package:get/get.dart';
import 'add_scene_actors_controller.dart';

class AddSceneActorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSceneActorsController>(() => AddSceneActorsController());
  }
}
