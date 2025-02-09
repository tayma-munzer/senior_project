import 'package:get/get.dart';
import 'package:senior_app/Actors/view_details_artwork_gallary/artwork_gallary_details_controller.dart';
import 'package:senior_app/Director/artwork_details/artwork_details_controller.dart';
import 'package:senior_app/Location%20Owner/view_location_owner_details/view_location_details_controller.dart';

class ArtworkGallaryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtworkGallaryDetailsController>(
        () => ArtworkGallaryDetailsController());
  }
}
