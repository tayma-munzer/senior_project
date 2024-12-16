// lib/artwork_details/artwork_details_binding.dart
import 'package:get/get.dart';
import 'artwork_details_controller.dart';

class ArtworkDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtworkDetailsController>(() => ArtworkDetailsController());
  }
}
