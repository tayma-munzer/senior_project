import 'package:get/get.dart';
import 'add_photos_filminglocation_controller.dart';

class AddPhotoFilmingLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPhotoFilmingLocationController>(
        () => AddPhotoFilmingLocationController());
  }
}
