import 'package:get/get.dart';

import 'add_filming_location_controller.dart';

class AddFilmingLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFilmingLocationController>(
        () => AddFilmingLocationController());
  }
}
