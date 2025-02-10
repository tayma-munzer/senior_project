import 'package:get/get.dart';
import 'package:senior_app/Director/director_home_page/director-home_controller.dart';

class DirectorHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectorHomeController>(() => DirectorHomeController());
  }
}
