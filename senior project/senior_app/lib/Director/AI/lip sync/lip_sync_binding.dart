import 'package:get/get.dart';
import 'package:senior_app/Director/AI/lip%20sync/lip_sync_controller.dart';

class LipSyncBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LipSyncController());
  }
}
