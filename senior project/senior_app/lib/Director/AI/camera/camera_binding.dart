import 'package:get/get.dart';
import 'camera_controller.dart';

class CameraBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraController());
  }
}
