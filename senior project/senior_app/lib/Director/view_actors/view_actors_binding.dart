import 'package:get/get.dart';
import 'package:senior_app/Director/view_actors/view_actors_controller.dart';

class ViewActorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewActorsController>(() => ViewActorsController());
  }
}
