import 'package:get/get.dart';
import 'add_location_controller.dart';

class AddLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLocationController>(() => AddLocationController());
  }
}
