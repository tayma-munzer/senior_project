import 'package:get/get.dart';
import 'package:senior_app/view_location_owner_details/view_location_details_controller.dart';

class ViewLocationOwnerLocationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewLocationOwnerLocationDetailsController>(
        () => ViewLocationOwnerLocationDetailsController());
  }
}
