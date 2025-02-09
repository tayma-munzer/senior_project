import 'package:get/get.dart';
import 'view_locations_controller.dart';

class ViewLocationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewLocationsController>(() => ViewLocationsController());
  }
}
