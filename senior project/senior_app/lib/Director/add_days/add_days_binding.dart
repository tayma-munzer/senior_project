import 'package:get/get.dart';
import 'add_days_controller.dart';

class AddDaysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDaysController>(() => AddDaysController());
  }
}
