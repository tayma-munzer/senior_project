import 'package:get/get.dart';
import 'package:senior_app/Director/AI/story%20board/story_board_controller.dart';

class StoryBoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoryBoardController());
  }
}
