import 'package:get/get.dart';
import 'favorite_location_controller.dart';

class FavoriteLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteLocationController());
  }
}
