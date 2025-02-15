import 'package:get/get.dart';
import 'package:senior_app/Director/AI/trailer%20generate/trailergenerate_controller.dart';

class TrailergeneraterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrailergeneraterController());
  }
}
