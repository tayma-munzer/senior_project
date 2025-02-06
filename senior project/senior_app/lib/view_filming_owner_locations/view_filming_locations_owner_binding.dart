import 'package:get/get.dart';
import 'view_filming_locations_owner_controller.dart';

class ViewOwnerFilmingLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewOwnerFilmingLocationController());
  }
}
