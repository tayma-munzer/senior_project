import 'package:get/get.dart';
import 'package:senior_app/Director/add_artwork/add_artwork_poster_controller.dart';

class AddArtworkPosterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddArtworkPosterController>(() => AddArtworkPosterController());
  }
}
