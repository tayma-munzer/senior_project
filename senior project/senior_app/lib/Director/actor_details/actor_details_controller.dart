import 'package:get/get.dart';

class ActorDetailsController extends GetxController {
  final actor = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      actor.value = args;
    } else {
      print("Error: Arguments are null or invalid");
    }
  }
}
