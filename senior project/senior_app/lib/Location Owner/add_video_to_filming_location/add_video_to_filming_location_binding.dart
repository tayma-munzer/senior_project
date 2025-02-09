import 'package:get/get.dart';
import 'package:senior_app/Location%20Owner/add_video_to_filming_location/add_video_to_filming_location_controller.dart';

class AddVideoToFilmingLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddVideoToFilmingLocationController>(
        () => AddVideoToFilmingLocationController());
  }
}
