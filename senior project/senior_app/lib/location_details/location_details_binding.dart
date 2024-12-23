import 'package:get/get.dart';
import 'package:senior_app/location_details/location_details_controller.dart';

class ViewLocationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewLocationDetailsController>(
        () => ViewLocationDetailsController());
  }
}
