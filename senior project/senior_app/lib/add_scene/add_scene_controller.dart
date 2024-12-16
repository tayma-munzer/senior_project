import 'package:get/get.dart';

class AddSceneController extends GetxController {
  var sceneName = ''.obs;

  var actors = [
    {
      "name": "Actor 1",
      "age": "45",
      "type": "Lead Role",
      "image": "assets/login.png"
    },
    {
      "name": "Actor 2",
      "age": "50",
      "type": "Supporting",
      "image": "assets/login.png"
    },
    {
      "name": "Actor 3",
      "age": "38",
      "type": "Guest Role",
      "image": "assets/login.png"
    },
  ].obs;

  var selectedActors = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    selectedActors.assignAll(List.filled(actors.length, false));
  }

  void toggleSelection(int index, bool value) {
    selectedActors[index] = value;
  }

  void submitScene() {
    print("Scene Name: ${sceneName.value}");
    print("Selected Actors:");
    for (int i = 0; i < actors.length; i++) {
      if (selectedActors[i]) {
        print("- ${actors[i]['name']}");
      }
    }

    // Get.to(
    //   () => AddSceneLocationView(),
    // );
  }

  void addActor() {
    print("aadd actor tapped");
  }
}
