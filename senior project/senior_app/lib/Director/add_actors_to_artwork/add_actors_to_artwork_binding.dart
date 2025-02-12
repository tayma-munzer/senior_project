import 'package:get/get.dart';
import 'package:senior_app/Director/add_actors_to_artwork/add_actors_to_Artwork_controller.dart';
import 'package:senior_app/Director/view_actors/view_actors_controller.dart';

class AddActorsToArtworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddActorsToArtworkController>(
        () => AddActorsToArtworkController());
  }
}
